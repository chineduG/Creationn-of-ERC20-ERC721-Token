// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract NeduToken{
    uint256 totalSupply=1000000;
    mapping (address => uint256) balances;
    mapping(address => mapping(address => uint256)) approved;

    event Transfer(address indexed from,address indexed to,uint amount);
    event Approval(address indexed from,address indexed to,uint amountKeep);


    constructor() {
        balances[msg.sender]=totalSupply;//setting balance of initiator of contract to total supply on initialization
    }


    function getTotalSupply() public view returns (uint256){
        return totalSupply;
    }

   

    function balance(address tokenOwner)public view returns (uint){
        return balances[tokenOwner];
    }


    function transfer(address receiver,uint numToken) public returns (bool) {
        require(numToken <= balances[msg.sender], "You don't have enough token");//makes sure the sender has enough token
        balances[msg.sender]=balances[msg.sender]-numToken;
        balances[receiver]=balances[receiver]+numToken;
        emit Transfer(msg.sender, receiver, numToken);//emit transfer event
        return true;

    }

    function approve(address delegate,uint numToken) public returns (bool){
        approved[msg.sender][delegate]=numToken;
        emit Approval(msg.sender, delegate, numToken);
        return true;
    }

    function getapprovedamount(address owner,address delegate)public view returns (uint){
        return approved[owner][delegate];
    }

    function transferfrom(address owner,address delegate,address receiver,uint numToken)public returns (bool){
        require(numToken<=balances[owner], "Insufficient balance");
        require(numToken<=getapprovedamount(owner, delegate),"Delegate account doesn't have access to enough tokens");
        balances[owner]=balances[owner]-numToken;
        approved[owner][delegate]=getapprovedamount(owner, delegate)-numToken;
        balances[receiver]=balances[receiver]+numToken;
        emit Transfer(owner,receiver,numToken);
        return true;
    }

    function buyToken(address receiver)public payable returns (bool){
        require(msg.value >= 1e15, "You must at least buy 1 token");
        uint tokenbought=msg.value/1e15;
        balances[receiver]=balances[receiver]+tokenbought;
        totalSupply=totalSupply+tokenbought;
        emit Transfer(msg.sender, receiver, tokenbought);
        return true;
    }
    

}