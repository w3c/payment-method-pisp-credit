@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments-flows/gh-pages/PaymentFlows/skin.ipml

participant "BANK B" as ASPSP2
Participant "Merchant" as Merchant
participant "PISP" as PISP
Actor "Alice" as PSU
participant "App" as APP
participant "Bank A" as ASPSP1

' ASPSP, PSU, PISP come from DSP2 definitions

Title PISP provides the App / 18 (tentative flowchart)

== Previous parametrization ==

PSU -[#black]> APP: Alice enters her \n account-identifier \n into a PISP Payment App

note right PSU
IBAN is a common identifier of 
the Bank through European countries
end note

Merchant <[#black]-> PISP : contract with mutual authentication in place


== shopping ==

PSU -> Merchant : Alice clicks "ok" to validate the shopping e-cart

== W3C payment request & response ==

Merchant -[#blue]> PSU : Payment Request

note right Merchant
this request contains multiple payment methods
including PISP credit  Payment
end note

note right PSU
Browser opens payment apps that match both with 
PaymentRequest & enrolled apps of Alice
end note

PSU -[#black]> APP : Alice chooses PISP credit Payment

APP -[#black]> PISP : App connects to PISP

group Credit Initiation (Alice see nothing on her browser)


PISP --> PISP : PISP found the URL of Bank \n of Alice using home made directory


PISP -[#blue]-> ASPSP1 : CustomerCreditTransferInitiation using the Credit initiation API of Bank of Alice
ASPSP1-[#green]-> ASPSP1 : authentication of PISP using Bank A made directory

note left ASPSP1
The bank made directory of PISP is made by concatenation
of regulated directories from European Authorities
end note

ASPSP1-[#blue]-> PISP : The Bank of Alice also provides the URL to be used for redirecting Alice browser (authentication URL)
end 

group Authentication of Alice
PISP -[#blue]-> APP: App of Alice is redirect to authentication URL of Bank of Alice
ASPSP1  -[#orange]-> APP : authentication challenge linked with amount & merchant

PSU -> APP : choice of the account
PSU -> APP : consent of the purchase by authentication

APP-[#orange]-> ASPSP1 :consent for the credit Transfer
ASPSP1 -[#green]-> ASPSP1 : preparing the credit transfer \n with bank controls
note left ASPSP1
the credit transfer is prepared but not yet validated
end note
ASPSP1 -[#blue]-> PISP: CustomerPaymentStatusReport (with OK or NOK)
ASPSP1 -[#blue]-> PSU : The bank redirects Alice to the PISP through the callback URLs provided by the PISP
end


PSU -[#blue]> Merchant : PaymentResponse is sent to merchant

PISP -[#blue]> ASPSP1 : confirm the credit transfer

note right PISP
the confirmation should be send "quickly" (less than one  minute)
the amount is not yet reserved in the bank account
end note 

PISP -[#blue]> Merchant : CreditorPaymentactivationRequestStatusReport


ASPSP1 -[#green]-> ASPSP1 : initiate the credit \n transfer into internal system



== Bank of Alice credits Bank of Merchant (batch mode) ==

ASPSP1 -[#green]> ASPSP2 : FIToFICustormerCreditTransfer


== Bank Notification of Merchant ==

ASPSP2 -[#green]-> Merchant : BankToCustomerDebitCreditNotification
@enduml
