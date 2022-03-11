// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// 用户参与的众筹项目映射 抽象为合约
contract VoteCrowdPros{
    // 1、用户所投资的所有总筹项目
    mapping(address => address[]) public votingCrowdPros;

    // 向映射中添加项目
    function addPro(address _sender, address _pro) public {
        votingCrowdPros[_sender].push(_pro);
    }

    // 返回项目
    function getPro(address _sender) view public returns(address[] memory) {
        return votingCrowdPros[_sender];
    }

}