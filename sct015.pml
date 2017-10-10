@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments-flows/gh-pages/PaymentFlows/skin.ipml

participant "BANK B" as BPSP
Participant "Merchant" as Beneficiary
participant "PISP" as PISP
Actor "Alice" as Originator
participant "Bank A" as APSP

Title PISP initiated Credit Transfer / 15

== Previous parametrization ==

Originator -[#black]> Originator : Alice enters her account-identifier into a PISP Payment App \n or a form filler of the browser

note right Originator
IBAN is a common identifier of the Bank through European countries
end note

Beneficiary <[#black]-> PISP : contract with mutual authentication in place
note left PISP
Merchant could have multiple PISP depending
 of Bank reachability they provide
Merchant could have PISP for PISP credit 
transfer and acquirer for cards that are differents
end note



== shopping ==

Originator -> Beneficiary : Alice clicks "ok" to validate the shopping e-cart

== W3C payment request & response ==

Beneficiary -[#blue]> Originator : Payment Request

note right Beneficiary
this request contains multiple payment methods
including PISP credit  Payment
end note
note right Originator
Browser opens payment apps that match both with 
PaymentRequest & enrolled apps of Alice
end note

Originator -[#black]> Originator : Alice choose PISP credit Payment

Originator -[#blue]> Beneficiary : PaymentResponse is sent to merchant

== PISP credit transfer intiation == 

Beneficiary -> Beneficiary : Merchant identify relevant PISP (if he gots multiple)

group Credit Initiation (Alice see nothing on her browser)

Beneficiary -[#blue]-> PISP : Merchant gives to PISP all data from Payment Request & Payment Response
note left PISP
authentication between merchant and PISP is out of scope
and is organised through direct relationship depending on PISP technology
end note
PISP --> PISP : PISP found the URL of Bank \n of Alice using home made directory

note right PISP
It seems that a major value added of PISP is to maintain
directory of all banks
end note

PISP -[#blue]-> APSP : CustomerCreditTransferInitiation using the Credit initiation API of Bank of Alice
APSP-[#green]-> APSP : authentication of PISP using Bank A made directory

note left APSP
The bank made directory of PISP is made by concatenation
of regulated directories from European Authorities
end note

APSP-[#blue]-> PISP : The Bank of Alice also provides the URL to be used for redirecting Alice browser (authentication URL)
end 

group Authentication of Alice
PISP -[#blue]-> Originator: Browser of Alice is redirect to authentication URL of Bank of Alice
APSP  -[#orange]-> Originator : authentication challenge linked with amount & merchant

note left Originator
the choice of the account is done at this level
end note

Originator -[#orange]-> APSP :consent for the credit Transfer
APSP -[#green]-> APSP : preparingthe credit transfer \n with bank controls
note left APSP
the credit transfer is initiated but not yet validated
end note
APSP -[#blue]-> PISP: CustomerPaymentStatusReport (with OK or NOK)
APSP -[#blue]-> Originator : The bank redirects Alice to the PISP through the callback URLs provided by the PISP
end

PISP -[#blue]> Beneficiary : CreditorPaymentactivationRequestStatusReport
Beneficiary -[#blue]> PISP : acknowledge the information of payment

PISP -[#blue]> APSP : confirm the credit transfer
note right PISP
the confirmation should be send "quickly" (less than one  minute)
the amount is note yet reserved in the bank account
end note
APSP -[#green]-> APSP : initiate the credit transfer into internal system

PISP -[#blue]-> Originator : Browser of Alice is redirect to Merchant

Beneficiary -> Originator : Merchant confirms the purchase

== Bank of Alice credits Bank of Merchant (batch mode) ==

APSP -[#green]> BPSP : FIToFICustormerCreditTransfer


== Bank Notification of Merchant ==

BPSP -[#green]-> Beneficiary : BankToCustomerDebitCreditNotification
@enduml
