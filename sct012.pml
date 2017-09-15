@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments-flows/gh-pages/PaymentFlows/skin.ipml

participant "BANK B" as BPSP
Participant "Merchant" as Beneficiary
participant "PISP" as PISP
Actor "Alice" as Originator
participant "Bank A" as APSP

== PISP credit transfer intiation (web mode) ==

Beneficiary -[#blue]> Originator : CreditorPaymentActivationRequest


Originator -[#blue]> Beneficiary : bank information (or account)
Beneficiary -[#blue]-> PISP : Browser of Alice is switched to PISP
PISP -> PISP : PISP found the authentication URL of Bank \n of Alice using regulated directory
PISP -[#blue]-> APSP : CustomerCreditTransferInitiation using the API of Bank of Alice
APSP-[#green]-> APSP : authentication of PISP using regulated directory
PISP -[#blue]-> APSP : Browser of Alice is switched to authentication URL of Bank of Alice
APSP  -[#orange]-> Originator : authentication challenge linked with amount & merchant
Originator -[#orange]-> APSP :consent for the credit Transfer
APSP -[#green]-> APSP : submitting credit transfer \n to internal systems
APSP -[#blue]-> PISP: CustomerPaymentStatusReport

PISP -[#blue]> Beneficiary : CreditorPaymentactivationRequestStatusReport


== Bank of Alice credits Bank of Merchant (batch mode )==

APSP -[#green]> BPSP : FIToFICustormerCreditTransfer


== Bank Notification of Merchant ==

BPSP -[#green]-> Beneficiary : BankToCustomerDebitCreditNotification
@enduml
