// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VampireFactory is Ownable {

    constructor() Ownable(msg.sender) {}

    event NewVampire(uint vampireId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Vampire {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Vampire[] public vampires;

    mapping (uint => address) public vampireToOwner;
    mapping (address => uint) ownerVampireCount;

    function _createVampire(string memory _name, uint _dna) internal {
        Vampire memory newVampire = Vampire(
            _name,
            _dna,
            1,
            uint32(block.timestamp + cooldownTime),
            0,
            0
        );
        vampires.push(newVampire);
        uint id = vampires.length - 1;
        vampireToOwner[id] = msg.sender;
        ownerVampireCount[msg.sender] = ownerVampireCount[msg.sender] + 1;
        emit NewVampire(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomVampire(string memory _name) public payable {
        require(ownerVampireCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createVampire(_name, randDna);
    }

}