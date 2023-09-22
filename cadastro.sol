/*
SPDX-License-Identifier: CC-BY-4.0
(c) Desenvolvido por Juliana Braz

Endereço de Contrato: 0xE56A295665c930EFD32A6701383302Eeb9E40C89 

This work is licensed under a Creative Commons Attribution 4.0 International License.
*/

pragma solidity 0.8.19;

import "https://github.com/jeffprestes/cursosolidity/blob/master/bradesco_token_aberto.sol";

contract Contrato{  

    Cliente public cliente;
    ExercicioToken private exercicioToken;

    struct Cliente {
        string primeiroNome;
        string sobreNome;
        address payable endereco; 
        bytes32 hashConta;       
        bool existe; 
    }

    constructor(string memory _primeiroNome,string memory _sobreNome,string memory _agencia, string memory _conta) {
        string memory strTemp = string.concat(_agencia, _conta);
        bytes memory bTemp = bytes(strTemp);
        bytes32 hashTemp = keccak256(bTemp);
        address _enderecoToken = 0x89A2E711b2246B586E51f579676BE2381441A0d0;

        cliente = Cliente(_primeiroNome, _sobreNome, payable(address(msg.sender)), hashTemp, true);
        exercicioToken = ExercicioToken(_enderecoToken);

        gerarTokenParaEuCliente(10000); 
        
    }

    function consultaMeuSaldo() public view returns(uint256) {
        return exercicioToken.balanceOf(address(this));
    }

    function gerarTokenParaEuCliente(uint256 _amount) public returns (bool){
        return exercicioToken.mint(address(this), _amount);
    }
       function transfereTokensTerceiro(address _endDestino, uint256 _amount) public returns (bool) {
        return exercicioToken.transfer(_endDestino, _amount);
    }

    function consultaSaldoNativo() public view returns(uint256) {
        return address(this).balance;
    }

    function transferenciaCriptoNativo(address payable _endDestino, uint256 _amount) public payable{
        require(_amount <= address(this).balance, "Saldo insuficiente");
        _endDestino.transfer(_amount);
    }

}
  

