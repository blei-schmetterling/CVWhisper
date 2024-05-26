// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JobContract {
    struct EmploymentStatus {
        uint256 timestamp;
        address changer;
        bool status;
        string jobDescription;
    }

    address public employer;
    mapping(address => bool) public employers;
    mapping(address => bool) public employees;
    mapping(address => EmploymentStatus[]) public employmentStatusHistory;

    event EmploymentStatusChanged(address indexed employee, address indexed changer, bool newStatus, string jobDescription); // Меняем тип события

    modifier onlyEmployer() {
        require(employers[msg.sender], "Only employer can call this function.");
        _;
    }

    modifier onlyEmployee() {
        require(employees[msg.sender], "Only employee can call this function.");
        _;
    }

    constructor() {
        // Initial employer setup
        employers[msg.sender] = true;
    }

    function addEmployer(address _employer) external {
        employers[_employer] = true;
    }

    function assignEmployee(address _employee) external {
        require(!employees[_employee], "Employee already hired.");
        employees[_employee] = true;
    }

    function setEmploymentStatus(address _employee, bool _status, string memory _jobDescription) external {
        employees[_employee] = _status;
        employmentStatusHistory[_employee].push(EmploymentStatus(block.timestamp, msg.sender, _status, _jobDescription)); // Добавляем описание вакансии
        emit EmploymentStatusChanged(_employee, msg.sender, _status, _jobDescription); // Изменяем событие
    }

    function getEmploymentStatus(address _employee) external view returns (bool) {
        return employees[_employee];
    }

    function getEmploymentStatusHistoryWithJobChange(address _employee) external view returns (EmploymentStatus[] memory) {
        uint256 jobChangeCount = 0;
        for (uint256 i = 0; i < employmentStatusHistory[_employee].length; i++) {
            if (keccak256(bytes(employmentStatusHistory[_employee][i].jobDescription)) != keccak256("")) { // Проверяем наличие описания вакансии
                jobChangeCount++;
            }
        }

        EmploymentStatus[] memory jobChangeHistory = new EmploymentStatus[](jobChangeCount);
        uint256 index = 0;
        for (uint256 i = 0; i < employmentStatusHistory[_employee].length; i++) {
            if (keccak256(bytes(employmentStatusHistory[_employee][i].jobDescription)) != keccak256("")) { // Проверяем наличие описания вакансии
                jobChangeHistory[index] = employmentStatusHistory[_employee][i];
                index++;
            }
        }

        return jobChangeHistory;
    }
}
