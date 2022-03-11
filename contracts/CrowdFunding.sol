// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./VoteCrowdPros.sol";

contract Crowd{
    // 1、众筹项目名
    // 2、众筹资金
    // 3、众筹每笔资金
    // 4、众筹项目截至时间
    // 5、投资人数组
    // 6、投资人字典
    // 7、花费申请数组
    address public manager;
    string public projectName;
    uint256 public totalCapital;
    uint256 public singleCapital;
    uint256 public endTimestamp;
    address[] public voters;
    mapping(address => bool) public investors;
    VoteCrowdPros votingCrowdpros;

    constructor(address _sender, string memory _projectName, uint256 _totalCapital, uint256 _singleCapital, uint256 _endTimestamp, VoteCrowdPros _votingCrowdpros) {
        manager = _sender;
        projectName = _projectName;
        totalCapital = _totalCapital * 10 ** 18;
        singleCapital = _singleCapital * 10 ** 18;
        endTimestamp = block.timestamp + _endTimestamp;
        votingCrowdpros = _votingCrowdpros;
    }
    // 投资
    function invest() public payable {
        assert(msg.value == singleCapital); // 1. 投资的金额必须满足每笔资金
        assert(investors[msg.sender] == false); //2.每个地址只能投资一次
        investors[msg.sender] = true;
        voters.push(msg.sender);
        votingCrowdpros.addPro(msg.sender, address(this));
    }

    // 申请状态枚举
    enum RequestStatus {toupiaoing, pizhui, wnachen}
    // 请求花费结构
    struct Resquest{
        // 1、买什么
        string costName;
        // 2、花多少
        uint256 costMoney;
        // 3、卖家地址
        address seller;
        // 4、获得票数
        uint256 votesNum;
        // 5、投票人员管理
        mapping(address=>bool) voted;
        // 6、申请当前状态
        RequestStatus status;
    }

    uint numRequests;
    mapping (uint => Resquest) public requestsMapping;
    // 花费申请
    function setRequest(string memory _costName, uint256 _costMoney, address _seller) public {
        // 1、项目人才能申请花费
        assert(msg.sender == manager);
        // 2、申请的花费不能超过余额
        assert(_costMoney <= address(this).balance);
        Resquest storage res = requestsMapping[numRequests++];
        res.costName = _costName;
        res.costMoney = _costMoney;
        res.seller = _seller;
        res.votesNum = 0;
        res.status = RequestStatus.toupiaoing;
    }
    // 投票
    function voting(uint256 i) public {

        // 1、只能是投资者才能投票
        assert(investors[msg.sender]);
        Resquest storage res = requestsMapping[i];
        // 确保是一个可投票的花费申请
        assert(res.costMoney != 0);
        // 2、每个人只能投一票
        assert(res.voted[msg.sender] == false);
        // 3、票数加1
        res.votesNum ++;
        res.voted[msg.sender] = true;
    }
    // 终结申请，判断是否通过，通过转载给卖家
    function finality(uint256 i) public {
        Resquest storage res = requestsMapping[i];
        // 1、只有众筹的人才有资格结束这个申请
        assert(msg.sender == manager);
        // 2、票数要大于一半
        assert(res.votesNum * 2 > voters.length);
        // 3、转账的金额必须小于于合约余额
        assert(res.costMoney <= address(this).balance);
        // 4、执行转账
        payable(res.seller).transfer(res.costMoney);
        // 5、修改状态为完结
        res.status =  RequestStatus.wnachen;
    }
    // 辅助函数
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }
    function getVoters() public view returns(address[] memory, uint256){
        return (voters, voters.length);
    }
}