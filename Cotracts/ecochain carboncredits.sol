pragma solidity ^0.8.0;

contract EcoChainCarbonCredits {
    string public name = "EcoChain Carbon Credit";
    string public symbol = "ECOC";
    uint8 public decimals = 0;
    uint256 public totalSupply;

    address public admin;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Retired(address indexed account, uint256 value);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function mint(address to, uint256 amount) external onlyAdmin {
        require(to != address(0), "Cannot mint to zero address");
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        require(to != address(0), "Invalid address");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "Invalid spender address");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(allowance[from][msg.sender] >= amount, "Allowance exceeded");
        require(to != address(0), "Invalid recipient");

        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowance[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function retire(uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance to retire");

        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Retired(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }
}
