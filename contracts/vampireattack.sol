// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./vampirehelper.sol";

contract VampireAttack is VampireHelper {
    uint randNonce = 0;
    uint attackVictoryProbability = 70;

    function randMod(uint _modulus) internal returns(uint) {
        randNonce = randNonce + 1;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }

    function attack(uint _vampireId, uint _targetId) external onlyOwnerOf(_vampireId) {
        Vampire storage myVampire = vampires[_vampireId];
        Vampire storage enemyVampire = vampires[_targetId];
        uint rand = randMod(100);
        if (rand <= attackVictoryProbability) {
            myVampire.winCount = myVampire.winCount + 1;
            myVampire.level = myVampire.level + 1;
            enemyVampire.lossCount = enemyVampire.lossCount + 1;
            feedAndMultiply(_vampireId, enemyVampire.dna);
        } else {
            myVampire.lossCount = myVampire.lossCount + 1;
            enemyVampire.winCount = enemyVampire.winCount + 1;
            _triggerCooldown(myVampire);
        }
    }
}
