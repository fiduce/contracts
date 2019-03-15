pragma solidity >=0.4.21 <0.6.0;

//import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
//import "openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";

import "./FiduceDeal.sol";

//contract Fiduce is ERC721Full, ERC721Mintable {
contract Fiduce is ERC721Full {

    uint8 public constant decimals = 0;
    event NewDeal(address indexed _agent, address indexed _client);

    constructor () public  ERC721Full("Fiduce Token", "FIDUCE")
    {
    }


    function createDeal(address client) public payable {
        FiduceDeal deal = new FiduceDeal();
        deal.initialize(msg.sender, client);
        emit NewDeal(msg.sender, client);
    }



}
