pragma solidity ^0.5.16;

contract ZombieFactory {
    uint256 dnaDigits = 16;
    uint256 dnaModulus = 10**dnaDigits;

    struct Zombie {
        string name;
        uint256 dna;
    }

    Zombie[] public zombies;

    // _createZombie 라는 private 함수 생성 인자는 2개 (string _name, uint _dna)
    function _createZombie(string _name, uint256 _dna) private {
        // 해당 함수는 전달받은 인자들로 새로운 Zombie를 생성하고 zombies배열에 추가하는 함수
        // Zombie zombie = Zombie(_name, _dna);
        // zombies.push(zombie);
        zombies.push(Zombie(_name, _dna));
    }

    // _generateRandomDna라는 private 함수를 만들고 인자는 (string _str) 반환타입은 (uint)
    // 이 함수는 컨트랙트 변수를 보지만 변경하지는 않을 것이므로 view로 선언.
    function _generateRandomDna(string _str) private view returns (uint256) {
        // 함수내용은 _str을 keccak256 해시값(fake random)을 구해서 uint256 rand에 저장
        // 해당 rand값을 16자리로 만들어서 반환 (hint: rand % ?
        // 545612348 --> 5자리의 난수로 만들려고 한다. 545612348 % 100000 ( 10**5)

        uint256 rand = keccak256(_str);
        return rand % dnaModulus;
    }

    // function sampleFunc() public view returns (stirng, uint256) {
    //     Zombie zombie = zombies[0];
    //     return (zombie.name, zombie.dna);
    // }

    // function sampleFunc2() public view {
    //     string name;
    //     (name, ) = sampleFunc();
    // }
}
