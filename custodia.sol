// SPDX-License-Identifier: MIT


pragma solidity 0.8.19;

import ";

contract Custodia{
    address public owner;
    address public enderecoToken;
    
    constructor(address _enderecoToken) {
        owner = msg.sender;
        tokenAddress = _enderecoToken;
    }

    function MeuSaldo() public view returns (uint256) {
        IERC20 token = IERC20(enderecoToken);
        return token.balanceOf(address(this));
    }

    function GerarTokenParaEuCliente(uint256 amount) public {
        require(msg.sender == owner, "Somente o proprietario pode gerar tokens.");
        
        IERC20 token = IERC20(tokenAddress);
        token.transfer(owner, amount);
    }
}


