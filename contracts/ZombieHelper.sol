pragma solidity ^0.5.16;

import "./ZombieFeeding.sol";

// changeName(uint _zombieId, string _newName)이라는 external 함수.
// --> 2레벨 이상인 좀비만 사용 가능하도록 구성
// 2. 함수 내용은 Tx 요청자와 zombie의 주인이 같은지 검증
//  힌트: require과 msg.sender
// 3. 이름바꾸기 기능 추가. 전달받은 _newName으로 사용
// 4. changeDna 함수 정의  인자 2개 (??), 접근제어자 (??), Level이 20이상일때만
// 가능하도록! (힌트: changeName과 비슷)
// 5. 함수 내용은 Tx요청자와 zombie 주인 같은지 검증하고 dna를 변경하게 함.

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
}
