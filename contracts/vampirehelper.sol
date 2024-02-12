// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./vampirefeeding.sol";

contract VampireHelper is VampireFeeding {

    uint levelUpFee = 0.001 ether;

    modifier aboveLevel(uint _level, uint _vampireId) {
        require(vampires[_vampireId].level >= _level);
        _;
    }

    function withdraw() external onlyOwner {
        address _owner = owner();
        payable(_owner).transfer(address(this).balance);
    }

    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    function levelUp(uint _vampireId) external payable {
        require(msg.value == levelUpFee);
        vampires[_vampireId].level = vampires[_vampireId].level + 1;
    }

    function changeName(uint _vampireId, string calldata _newName) external aboveLevel(2, _vampireId) onlyOwnerOf(_vampireId) {
        vampires[_vampireId].name = _newName;
    }

    function changeDna(uint _vampireId, uint _newDna) external aboveLevel(20, _vampireId) onlyOwnerOf(_vampireId) {
        vampires[_vampireId].dna = _newDna;
    }

    function getVampiresByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerVampireCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < vampires.length; i++) {
            if (vampireToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
