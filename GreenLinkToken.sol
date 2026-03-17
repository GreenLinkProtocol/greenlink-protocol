// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
    Tango Master (TMDT)
    - Fixed Supply (5,000,000)
    - No Mint
    - No Tax
    - No Blacklist
    - No Honeypot Logic
    - Upgradable Name & Symbol
    - Simple Owner (only for metadata update)
*/

contract TangoMaster {

    // ================= Token Metadata =================

    string public name = "Tango Master";
    string public symbol = "TMDT";
    uint8 public constant decimals = 18;

    uint256 public constant totalSupply = 5_000_000 * 10**18;

    address public owner;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // ================= Events =================

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event MetadataUpdated(string newName, string newSymbol);

    // ================= Constructor =================

    constructor() {
        owner = msg.sender;
        _balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // ================= Modifiers =================

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // ================= ERC20 Standard =================

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address holder, address spender) public view returns (uint256) {
        return _allowances[holder][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= amount, "ERC20: insufficient allowance");

        _allowances[from][msg.sender] = currentAllowance - amount;
        emit Approval(from, msg.sender, _allowances[from][msg.sender]);

        _transfer(from, to, amount);
        return true;
    }

    // ================= Internal Transfer =================

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "Transfer from zero address");
        require(to != address(0), "Transfer to zero address");

        uint256 senderBalance = _balances[from];
        require(senderBalance >= amount, "Transfer exceeds balance");

        _balances[from] = senderBalance - amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    // ================= Metadata Update =================

    function updateMetadata(string memory newName, string memory newSymbol) external onlyOwner {
        name = newName;
        symbol = newSymbol;
        emit MetadataUpdated(newName, newSymbol);
    }
}