pragma solidity ^0.5.16;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {
    // withdraw 함수 만들기(ZombieHelper.sol)
    // 1. withdraw함수를 정의하여라  잔고 전액 인출하는 함수
    // 2. 이더리움 가격이 변화하기 때문에, levelUpFee를 설정시키는
    // setLevelUpFee(uint _fee) 함수 생성  오직 owner만 호출 가능하도록
    uint256 levelUpFee = 0.001 ether;

    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    /**
     * withdraw: 주어진 parameter만큼 인출
     */
    function withdraw(uint256 _amount) external onlyOwner {
        _withdraw(_amount);
    }

    /**
     * withdrawAll: 전액 인출
     */
    function withdrawAll() external onlyOwner {
        _withdraw(address(this).balance);
    }


    function _withdraw(uint256 _amount) private onlyOwner {
        require(_amount <= address(this).balance);
        address payable owner = address(uint160(owner()));
        owner.transfer(_amount);
    }

    function levelUp(uint256 _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level = zombies[_zombieId].level.add(1);
    }

    // setLevelUpFee - levelUpFee를 변경시킬 수 있는 함수
    // 1. external(외부에서 호출)
    // 2. owner만 호출이 가능해야 한다.
    function setLevelUpFee(uint256 _fee) external onlyOwner {
        // require(owner()==msg.sender) --> 현재 setLevelUp을 호출한 tx이 owner가 호출한 tx인지
        // logic
        levelUpFee = _fee;
    }

    function changeName(uint256 _zombieId, string calldata _newName)
        external
        aboveLevel(2, _zombieId)
        zombieOwnerOf(_zombieId)
    {
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint256 _zombieId, uint256 _newDna)
        external
        aboveLevel(20, _zombieId)
        zombieOwnerOf(_zombieId)
    {
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
                zombieCount = zombieCount.add(1);
            }
        }

        // 3.   result를 return한다.
        return result;
    }
}
