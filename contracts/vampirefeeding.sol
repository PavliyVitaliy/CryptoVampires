// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./vampirefactory.sol";

contract VampireFeeding is VampireFactory {

    modifier onlyOwnerOf(uint _vampireId) {
        require(msg.sender == vampireToOwner[_vampireId]);
        _;
    }

    function _triggerCooldown(Vampire storage _vampire) internal {
        _vampire.readyTime = uint32(block.timestamp + cooldownTime);
    }

    function _isReady(Vampire storage _vampire) internal view returns (bool) {
        return (_vampire.readyTime <= block.timestamp);
    }

    function feedAndMultiply(uint _vampireId, uint _targetDna) internal onlyOwnerOf(_vampireId) {
        Vampire storage myVampire = vampires[_vampireId];
        require(_isReady(myVampire));
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myVampire.dna + _targetDna) / 2;
        _createVampire("NoName", newDna);
        _triggerCooldown(myVampire);
    }

}