pragma solidity ^0.5.16;

contract ZombieFactory {
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    event NewZombie(uint256 ZombieId, string name, uint256 dna);

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    // _createZombie 라는 private 함수 생성 인자는 2개 (string _name, uint _dna)
    function _createZombie(string memory _name, uint256 _dna) private {
        // 해당 함수는 전달받은 인자들로 새로운 Zombie를 생성하고 zombies배열에 추가하는 함수
        // Zombie zombie = Zombie(_name, _dna);
        // zombies.push(zombie);
        uint256 zombieId = zombies.push(Zombie(_name, _dna)) - 1;
        // Zombie 만들어졌어요(contract->FrontEnd)
        emit NewZombie(zombieId, _name, _dna);
    }

    // _generateRandomDna라는 private 함수를 만들고 인자는 (string _str) 반환타입은 (uint)
    // 이 함수는 컨트랙트 변수를 보지만 변경하지는 않을 것이므로 view로 선언.
    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        // 함수내용은 _str을 keccak256 해시값(fake random)을 구해서 uint256 rand에 저장
        // 해당 rand값을 16자리로 만들어서 반환 (hint: rand % ?
        // 545612348 --> 5자리의 난수로 만들려고 한다. 545612348 % 100000 ( 10**5)

        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        uint256 randData = _generateRandomDna(_name);
        _createZombie(_name, randData);
    }
}
