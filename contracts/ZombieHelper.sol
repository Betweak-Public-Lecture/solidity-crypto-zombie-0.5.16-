pragma solidity ^0.5.16;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    function changeName(uint256 _zombieId, string calldata _newName)
        external
        aboveLevel(2, _zombieId)
    {
        require(zombieToOwner[_zombieId] == msg.sender);
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint256 _zombieId, uint256 _newDna)
        external
        aboveLevel(20, _zombieId)
    {
        require(zombieToOwner[_zombieId] == msg.sender);
        zombies[_zombieId].dna = _newDna;
    }

    function getZombiesByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](ownerZombieCount[_owner]);

        uint256 zombieCount = 0;

        // 1.   전체 좀비의 수만큼 반복한다.
        for (uint256 i = 0; i < zombies.length; i++) {
            // i: zombie의 id (index)
            if (_owner == zombieToOwner[i]) {
                // 2.   각 좀비마다 owner를 확인하고 비교한다.
                // 2-1. 좀비의 owner가 _owner와 같으면 result에 추가한다.
                result[zombieCount] = i;
                zombieCount++;
            }
        }

        // 3.   result를 return한다.
        return result;
    }
}
