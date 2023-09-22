// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "contracts/token.sol";
import "contracts/cadastro.sol";

contract CustodiaTokens{
    address public administrador;
    address public enderecoToken;
    ExercicioToken public exercicioToken;
    Cadastro public cadastro;
    
    constructor(address _enderecoToken) {
        administrador = msg.sender;
        enderecoToken = _enderecoToken;
        exercicioToken = ExercicioToken(_enderecoToken);
        
    }

    function MeuSaldo() public view returns (uint256) {
        IERC20 token = IERC20(enderecoToken);
        return token.balanceOf(address(this));
    }

   }

