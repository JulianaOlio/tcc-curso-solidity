//SPDX-License-Identifier: CC-BY-4.0

// CONTRACT: 0x2765AAF0CD47FB0FDB3461BaDe1aAA49b69cc162

pragma solidity 0.8.19;

import "https://github.com/jeffprestes/cursosolidity/blob/master/bradesco_token_aberto.sol";


contract Cadastro{

    Cliente private cliente;
    ExercicioToken private exercicioToken;
    CustodiaToken private custodia;

    struct Cliente {
        string primeiroNome;
        string sobreNome;
        address payable endereco; 
        bytes32 hashConta;       
        bool existe; 
    }

    constructor(string memory _primeiroNome,string memory _sobreNome,string memory _agencia, string memory _conta, address _enderecoToken) {
        string memory strTemp = string.concat(_agencia, _conta);
        bytes memory bTemp = bytes(strTemp);
        bytes32 hashTemp = keccak256(bTemp);
        cliente = Cliente(_primeiroNome, _sobreNome, payable(address(custodia)), hashTemp, true);
        custodia = new CustodiaToken(hashTemp,_enderecoToken );
        exercicioToken = ExercicioToken(_enderecoToken);
    }

    function meuSaldo() public view returns(uint256) {
        return custodia.meuSaldo();
    }

    function gerarTokenParaEuCliente(uint256 _amount) public returns (bool){
        return custodia.gerarTokens(_amount);
    }

    function transferenciaDeTokens(address _to, uint256 _amount) public returns (bool) {
        return custodia.TransferirTokensParaTerceiro(_to, _amount);
    }

   
}

contract CustodiaToken {
    
    bytes32 private hashConta;
    ExercicioToken private token;
    address private cliente;
    event EtherRecebido();

    address payable public owner; 

    constructor (bytes32 _hashConta, address _enderecoToken) {
        hashConta = _hashConta;
        cliente = msg.sender;
        token = ExercicioToken(_enderecoToken);
    }

    function meuSaldo() public view returns(uint256) {
       return token.balanceOf(address(this));
    }

    function gerarTokens(uint256 _amount) public returns (bool){
            require(msg.sender == owner, "Somente Owner pode gerar tokens");
            require(token.balanceOf(address(this)) >= _amount, "Saldo insuficiente no contrato");
        return token.mint(address(this), _amount);
    }
  

    function TransferirTokensParaTerceiro(address _to, uint256 amount) public returns (bool) {
        require(msg.sender == cliente || msg.sender == owner, "Somente o cliente e/ou propritario podem transferir tokens de uma conta.");
        require(_to != address(0), "Endereco de destino invalido.");
        require(address(this).balance >= amount, "Saldo insuficiente.");

        return token.transfer(_to, amount);
    }

   
   
    receive() external payable {
        emit EtherRecebido();
    }
    
}



  
