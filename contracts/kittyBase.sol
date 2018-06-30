pragma solidity ^0.4.19;

import "./kittyControl.sol";
contract kittyBase is kittyControl{
    /// @dev 小猫出生时的事件，包括giveBirth和0代猫的创建
    event Birth(address owner, uint256 kittyId, uint256 matronId, uint256 sireId, string genes);

    /// @dev ERC721定义的转让事件，当kitty的主人变换时调用（包括出生）
    event Transfer(address from, address to, uint256 tokenId);

    //猫的数据结构
    struct Kitty{
        string genes; //基因
        uint64 cooldown; //可生育的冷却时间
        uint64 birthTime; //出生时间
        uint32 matronId; // 双亲ID
        uint32 sireId;
        uint64 generation; //代数
    }
    //存储所有猫的数组
    Kitty[] public kitties;
    uint cooldownTime = 2 minutes;

    mapping(uint256 => address) public kittyToOwner;  //猫ID对应主人地址
    mapping(address => uint256) ownerTokenCount;   //主人对应猫的数
    mapping(uint256 => address) kittyApproves;    //approval

    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        ownerTokenCount[_to]++;
        // 设置主人
        kittyToOwner[_tokenId] = _to;
        // 需要规避原来主人是0x0的情况
        if (_from != address(0)) {
            ownerTokenCount[_from]--;
        }
        // 发出主人转换事件
        emit Transfer(_from, _to, _tokenId);
    }
    function _setCooldownTime(uint256 _tokenId) internal  {
        Kitty storage _kitty = kitties[_tokenId];
        _kitty.cooldown = uint64(now + cooldownTime);
    }


    //创建猫的函数
    function createKitty(
        address _to,
        string _genes,
        uint256 _matronId,
        uint256 _sireId,
        uint32 _generation
    ) public returns(uint256) {
        Kitty memory _kitty;
        uint256 _tokenId;
        if (_generation == 0) {
            _kitty = Kitty({
                genes:_genes,
                cooldown:uint64(now + cooldownTime),
                birthTime:uint64(now),
                matronId:uint32(0),
                sireId:uint32(0),
                generation:uint64(_generation)
            });
            _tokenId = kitties.push(_kitty) - 1;
            kittyToOwner[_tokenId] = _to;
            ownerTokenCount[_to]++;
        } else {
         _kitty = Kitty({
                    genes:_genes,
                    cooldown:uint64(now + cooldownTime),
                    birthTime:uint64(now),
                    matronId:uint32(_matronId),
                    sireId:uint32(_sireId),
                    generation:uint64(_generation)
            });

            _tokenId = kitties.push(_kitty) - 1;
            kittyToOwner[_tokenId] = _to;
            ownerTokenCount[_to]++;

            _setCooldownTime(_matronId);
            _setCooldownTime(_sireId);
        }
        //birth事件事件
        emit Birth(_to, _tokenId, _matronId, _sireId, _genes);


        //设置
        emit Transfer(0, _to, _tokenId);
        return _tokenId;
    }

    //获取所有猫咪
    function getKitties() public view returns(uint[]) {
        uint[] memory _result = new uint[](kitties.length);
        uint counter = 0;

        for (uint i = 0; i < kitties.length; i++ ) {
            _result[counter] = i;
            counter++;
        }
        return _result;
    }

}

