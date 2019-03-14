pragma solidity 0.5.4;

contract CampaignFactory{
    
    address[] public deployedCampaigns;
    
     function createCampaign(uint minimum) public{
         
        address newCampaign = address(new Campaign(minimum, msg.sender));
        deployedCampaigns.push(newCampaign);
        
    }
    
    function getDeployedCampaigns() public view returns (address[] memory){
        
        return deployedCampaigns;
    }
    
}



contract Campaign{
    
    struct Request{
        string description;
        uint value;
        address payable manufacturer;
        bool complete;
        uint approvalCounts;
        mapping (address => bool) approvals;                //Yes or No for a request
        
    }
    
    Request[] public requests;
    
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }

    constructor(uint minimum, address creator) public{
        
        minimumContribution = minimum;
        manager = creator;
        
    }
    
    function contribute() public payable {
        
        require(msg.value >= minimumContribution);
        
        approvers[msg.sender] = true;
        approversCount = approversCount + 1;
        
    }
    
    function createRequest(string memory description, uint value, address payable manufacturer) public restricted{
        
        Request memory newRequest = Request({
            
            description: description,
            value: value,
            manufacturer: manufacturer,
            complete: false,
            approvalCounts: 0
            
        });
        
        requests.push(newRequest);
        
    }
    
    function approveRequest(uint index) public {
        
        Request storage Savedrequests = requests[index];
        
        require(approvers[msg.sender]);
        require(Savedrequests.approvals[msg.sender] == false);
        
        Savedrequests.approvals[msg.sender] = true;
        Savedrequests.approvalCounts = Savedrequests.approvalCounts + 1;
        
    }
    
    function finalizeRequest(uint index) public payable restricted{
        
        Request storage Savedrequests = requests[index];
        
        require(Savedrequests.approvalCounts > Savedrequests.approvalCounts / 2);
        require(Savedrequests.complete == false);
        
        Savedrequests.complete = true;
        Savedrequests.manufacturer.transfer(Savedrequests.value);
        
    }
    
    function getSummary() public view returns(uint, uint, uint, uint, address){
        
        minimumContribution;
        address(this).balance;
        requests.length;
        approversCount;
        manager;
        
    }
    
    function getRequestCount() public view returns (uint){
        
        return requests.length;
        
    }
    
}