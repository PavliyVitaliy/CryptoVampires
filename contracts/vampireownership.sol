// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "./vampireattack.sol";

contract VampireOwnership is VampireAttack, IERC721 {

    mapping (uint => address) vampireApprovals;

    function balanceOf(address _owner) external view returns (uint256) {
        return ownerVampireCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return vampireToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerVampireCount[_to] = ownerVampireCount[_to] + 1;
        ownerVampireCount[msg.sender] = ownerVampireCount[msg.sender] - 1;
        vampireToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external {
          require (vampireToOwner[_tokenId] == msg.sender || vampireApprovals[_tokenId] == msg.sender);
          _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external onlyOwnerOf(_tokenId) {
          vampireApprovals[_tokenId] = _approved;
          emit Approval(msg.sender, _approved, _tokenId);
    }


    // for implementation
    function getApproved(uint256 tokenId) external view returns (address operator) {}
    function isApprovedForAll(address owner, address operator) external view returns (bool) {}
    function setApprovalForAll(address operator, bool approved) external {}
    function safeTransferFrom(address from, address to, uint256 tokenId) external {}
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external {}
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {}
}
