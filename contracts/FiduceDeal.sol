pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "zos-lib/contracts/Initializable.sol";
import "./User.sol";

contract FiduceDeal is Ownable,Initializable {
    User _client;
    User _agent;
    User _bank;

    enum  state {Created, Initial }


    constructor () public {
        state = Initial;
    }

    function initialize(address agent, address client) onlyOwner initializable {
        _agent = agent;
        _client = client;

    }
    function setBank(address bank) onlyOwner public {
        _bank = bank;
    }
    function addDocument(address document) onlyOwner public {

    }


}
