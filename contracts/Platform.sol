// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./CrowdFunding.sol";
import "./VoteCrowdPros.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Platform is Ownable{
    address private _owner; // 合约管理员
    // 1、平台所有的总筹项目
    address[] public CrowdPros;
    // 2、用户发起的所有众筹项目
    mapping(address => address[]) public sponsorCrowdPros;
    // 3、用户参与的所有众筹项目
    VoteCrowdPros private votingCrowdpros;

    constructor() {
        _owner = msg.sender;
        votingCrowdpros = new VoteCrowdPros();
    }

    // 创建项目（用户自己调用）
    function createCrowd(address _sender, string memory _name, uint256 _totalCapital, uint256 _singleCapital, uint256 _endingTimeStamp) public {
        address crowd = address(new CrowdFunding(_sender, _name, _totalCapital, _singleCapital, _endingTimeStamp, votingCrowdpros));
        CrowdPros.push(crowd); // push 到平台的项目数组中
        sponsorCrowdPros[msg.sender].push(crowd); // push 到用户发起的项目映射中去
    }

    // 返回所有的项目数组
    function getAllCrowd() public view returns(address[] memory) {
        return CrowdPros;
    }

    // 返回用户自己的项目映射；
    function getSponsorCrowd() public view returns(address[] memory) {
        return sponsorCrowdPros[msg.sender];
    }

    // 返回用户自己的项目映射；
    function getVotingCrowdpros() public view returns(address[] memory) {
        return votingCrowdpros.getPro(msg.sender);
    }

}