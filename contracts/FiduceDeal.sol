pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "zos-lib/contracts/Initializable.sol";
import "./User.sol";

contract FiduceDeal is Ownable,Initializable {

    address _buyer;
    address _agent;
    address _bank;
    address _bankAdviser;
    address _broker;
    address _notary;
    address _fiduceAdviser;
    address _warranty;
    address _insurance;
    address _reserveInsurance;


    bool signedByBuyer = false;
    bool signedByNotary = false;
    bool signedByAgent = false;


    uint256[] ipfsDocuments;
    event newIpfsDocument(uint256 indexed _document, address indexed _addedBy);
    event documentsChecked(address indexed checker);

    enum  SignedBy {
        None,
        Agent,
        Notary
    }

    SignedBy sale_agreement;


    enum  State {
        Created,
        Initial,
        SaleAgreementSigned,
        DocumentsCheckedByBrocker,
        LoanMounted,
        LoanCheckedByBrocker,
        LoanMountedByBank,
        DocumentsCheckedByBankAdviser,
        DocumentsCheckedByWarranty,
        ApprovalInPrincipleByReserveInsurance,
        GoNGoApprovalFromLoaner,
        DocumentsCheckedByBuyer,
        DocumentsCheckedByInsurance,
        InsuranceDocumentsCheckedByBank,
        LendingOfferUpdated,
        LendingOfferAcceptedByBuyer,
        DealClosed,



        End


    }
    State state;

    function closeDeal() public {
        require(isBank());
        require(signedByBuyer == true && signedByAgent == true && signedByNotary == true);
        state = State.DealClosed;
    }

    function finalSignature() public {
        require( isBuyer() || isNotary() || isAgent());
        require(state == State.LendingOfferAcceptedByBuyer);
        if (isBuyer()) {
            signedByBuyer = true;
        } else if( isAgent()) {
            signedByAgent = true;
        } else if( isNotary() ) {
            signedByNotary = true;
        }
    }

    function acceptLendingOffer() public {
        require( isBuyer());
        require(state == State.LendingOfferUpdated);
        state = State.LendingOfferAcceptedByBuyer;
        emit documentsChecked(msg.sender);
    }



    function updateLendingOffer(uint256 document_hash) public {
        require( isBank());
        require(state == State.InsuranceDocumentsCheckedByBank);
        ipfsDocuments.push(document_hash);
        state = State.LendingOfferUpdated;
    }


    function checkLoanDocumentsByBank() public {
        require( isBank());
        require(state == State.DocumentsCheckedByInsurance);
        state = State.InsuranceDocumentsCheckedByBank;
        emit documentsChecked(msg.sender);
    }



    function checkDocumentsByInsurance() public {
        require( isInsurance());
        require(state == State.DocumentsCheckedByBuyer);
        state = State.DocumentsCheckedByInsurance;
        emit documentsChecked(msg.sender);
    }


    function setInsurance(address insurance) public {
        require(isOwner() || isBuyer() || isBroker());
        require(state == State.DocumentsCheckedByBuyer);
        require(_insurance == address(0));
        _insurance = insurance;
    }




    function checkDocumentsByBuyer() public {
        require( isBuyer());
        require(state == State.GoNGoApprovalFromLoaner);
        state = State.DocumentsCheckedByBuyer;
        emit documentsChecked(msg.sender);
    }



    function goNGoApprovalFromLoaner() public {
        require( isBuyer());
        require(state == State.ApprovalInPrincipleByReserveInsurance);
        state = State.GoNGoApprovalFromLoaner;

    }

    function approvalInPrincipleByReserveInsurance() public {
        require( isReserveInsurance());
        require(state == State.DocumentsCheckedByWarranty);
        state = State.ApprovalInPrincipleByReserveInsurance;

    }


    function checkDocumentsByWarranty() public {
        require( isWarranty());
        require(state == State.DocumentsCheckedByBankAdviser);
        state = State.DocumentsCheckedByWarranty;
        emit documentsChecked(msg.sender);
    }


    function setWarranty(address warranty) public {
        require(isOwner() || isBuyer() || isBroker());
        require(state == State.DocumentsCheckedByBankAdviser);
        require(_warranty == address(0));
        _warranty = warranty;
    }



    function checkDocumentsByBankAdviser() {
        require( isBankAdviser());
        require(state == State.LoanMountedByBank);
        state = State.DocumentsCheckedByBankAdviser;
        emit documentsChecked(msg.sender);
    }


    function mountLoanByBank() {
        require( isBank());
        require(state == State.LoanCheckedByBrocker && _bank != address(0));
        state = State.LoanMountedByBank;
    }

    function setBank(address bank,address adviser) public {
        require(isOwner() || isBuyer() || isBroker());
        require(state == State.LoanCheckedByBrocker);
        require(_bank == address(0));
        require(bank != address(0));
        require(adviser != address(0));
        _bank = bank;
        _bankAdviser = adviser;
    }



    function checkLoanByBrocker() public {
        require( isBroker());
        require(state == State.LoanMounted);
        state = State.LoanCheckedByBrocker;
    }


    function mountLoan() public {
        require( isBroker());
        require(state == State.DocumentsCheckedByBrocker);
        state = State.LoanMounted;
    }


    function checkDocumentsByBrocker() public {
        require( isBroker());
        require(state == State.SaleAgreementSigned);
        state = State.DocumentsCheckedByBrocker;
        emit documentsChecked(msg.sender);


    }

    function addDocumentByUser(uint256 document_hash) public {
        require(isBuyer()() || isBroker());
        require(state == State.SaleAgreementSigned);
        ipfsDocuments.push(document_hash);
        emit newIpfsDocument(document_hash,msg.sender);
    }


    function setBroker(address broker) public {
        require(isOwner() || isBuyer());
        require(state == State.SaleAgreementSigned);
        require(_broker == address(0) );
        _broker = broker;
    }


    function signSaleAgreement() public {
        require(state == State.Initial);
        require(isAgent() || isNotary());
        state = State.SaleAgreementSigned;
        if( isNotary() ) {
            sale_agreement = SignedBy.Notary;
        } else {
            sale_agreement = SignedBy.Agent;
        }
    }

    // check
    function isBuyer() public view returns (bool) {
        return msg.sender == _buyer;
    }

    function isAgent() public view returns (bool) {
        return msg.sender == _agent;
    }

    function isBank() public view returns (bool) {
        return msg.sender == _bank;
    }

    function isBankAdviser() public view returns (bool) {
        return msg.sender == _bankAdviser;
    }

    function isBroker() public view returns (bool) {
        return msg.sender == _broker;
    }

    function isNotary() public view returns (bool) {
        return msg.sender == _notary;
    }

    function isFiduceAdviser() public view returns (bool) {
        return msg.sender == _fiduceAdviser;
    }

    function isWarranty() public view returns (bool) {
        return msg.sender == _warranty;
    }

    function isInsurance() public view returns (bool) {
        return msg.sender == _insurance;
    }

    function isReserveInsurance() public view returns (bool) {
        return msg.sender == _reserveInsurance;
    }

    constructor () public {
        state = State.Created;
        sale_agreement = SignedBy.None;
    }

    function initialize(address agent, address buyer, address fiduceAdviser) onlyOwner initializer public {
        _agent  = agent;
        _buyer = buyer;
        _fiduceAdviser = fiduceAdviser;
        state = State.Initial;
    }


    function initialize(address agent, address buyer, address fiduceAdviser, address notary) onlyOwner initializer public {
        _agent  = agent;
        _buyer = buyer;
        _notary = notary;
        _fiduceAdviser = fiduceAdviser;
        state = State.Initial;
    }







    function addDocument(uint256 document_hash) onlyOwner public {
        ipfsDocuments.push(document_hash);
    }



}
