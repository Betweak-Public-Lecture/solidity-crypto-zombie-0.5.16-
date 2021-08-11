pragma solidity ^0.5.16;

import "./ZombieBattle.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ZombieOwnership is ZombieBattle, IERC721 {
    mapping (uint256 => address) zombieApprovals;

    /**
     * address _owner가 소유한 좀비의 개수. (token=zombie)
     */
    function balanceOf(address _owner) public view returns(uint256){
        return ownerZombieCount[_owner];
    }

    /**
     * 토큰Id(우리의 경우 zombieId)를 받아 소유주의 address를 반환
     */
    function ownerOf(uint256 _tokenId) public view returns(address){
        return zombieToOwner[_tokenId];
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public{
        require(zombieToOwner[_tokenId]==msg.sender || zombieApprovals[_tokenId]==msg.sender);
        _transfer(_from, _to, _tokenId);
    }

    /**
     * 실제로 소유권을 전달하는 함수
     */
    function _transfer(address _from, address _to, uint256 _tokenId) private{
        // 1. 소유권 이전
        zombieToOwner[_tokenId] = _to;
        // 2. Zombie 개수 sync
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        emit Transfer(_from, _to, _tokenId);
    }

    /**
     * 소유권 이전을 허용하는 함수. 
     * zombieApprovals에 추가.
     */
     function approve(address _to, uint256 _tokenId) public zombieOwnerOf(_tokenId){
        zombieApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
     }

     /**
      * burn (소각): 0번 어드레스로 보내버리자.
      */
    function burn(uint256 _tokenId) external zombieOwnerOf(_tokenId){
        zombieToOwner[_tokenId] = address(0);
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].sub(1);
    }

}
