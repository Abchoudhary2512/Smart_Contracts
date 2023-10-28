// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract lottery{
    address public manager;
    address payable[] public players;
    constructor(){
        manager = msg.sender;
    }
    function alreadyEntered() view private returns(bool) {
        for(uint i=0;i<players.length;i++){
            if(players[i]==msg.sender)
            return true;
        }
        return false;
    }
    function enter() payable public {
        require(msg.sender != manager,"Manger Can't Enter the lottery");
        require(alreadyEntered() == false,"Player already entered");
        require(msg.value >= 1 ether,"Minimum amount must be payed");
        players.push(payable(msg.sender));
    }
    function random() view private returns(uint){
        return uint(sha256(abi.encodePacked(block.difficulty,block.number,players)));
    } 
    function pickWinner() public {
        require(msg.sender == manager,"only manager can do it");
        uint index = random()%players.length; //winner index(generated randomly)
        address contractAddress = address(this);
        players[index].transfer(contractAddress.balance);
        players  =  new address payable[](0); //for reseting the lottery



    }
    function getPlayers()  view public returns ( address payable[] memory){
        return players;
    }
}