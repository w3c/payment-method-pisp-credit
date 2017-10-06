@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments-flows/gh-pages/PaymentFlows/skin.ipml

participant "BANK B" as BPSP
Participant "Merchant" as Beneficiary
participant "PISP" as PISP
Actor "Alice" as Originator
participant "Bank A" as APSP

Title Initiation First

== Previous parametrization ==

Originator -[#black]> Originator : Alice enters her Bank identifier into \n a form filler of the browser

note right Originator
The first 15th characters of the IBAN
are a common identifier of the Bank through European countries
end note

== shopping ==

Originator -> Beneficiary : Alice clicks "ok" to validate the shopping e-cart

== PISP credit transfer intiation ==

Beneficiary -[#blue]> Originator : CreditorPaymentActivationRequest

note right Beneficiary
this request contains multiple payment methods
including PISP credit  Payment
end note
note left Originator
At this stage the choice of 
the Payment method is not done
end note

Originator -[#black]> Originator : Alice choose PISP credit Payment

Originator -[#blue]> Beneficiary : bank identifier of Alice is sent to merchant

group Credit Initiation (background mode)
Beneficiary -[#blue]-> PISP : Merchant gives Alice Bank identifier to PISP
note left PISP
authentication between merchant and PISP is out of scope
and is organised through direct relationship depending on PISP technology
end note
PISP --> PISP : PISP found the URL of Bank \n of Alice using regulated directory
PISP -[#blue]-> APSP : CustomerCreditTransferInitiation using the Credit initiation API of Bank of Alice
APSP-[#green]-> APSP : authentication of PISP using regulated directory
APSP-[#blue]-> PISP : The Bank of Alice also provides the URL to be used for redirecting Alice browser (authentication URL)
end 

group Atthentication of Alice
PISP -[#blue]-> Originator: Browser of Alice is redirect to authentication URL of Bank of Alice
APSP  -[#orange]-> Originator : authentication challenge linked with amount & merchant

note left Originator
the choice of the account is done at this level
end note

Originator -[#orange]-> APSP :consent for the credit Transfer
APSP -[#green]-> APSP : submitting credit transfer \n to internal systems
APSP -[#blue]-> PISP: CustomerPaymentStatusReport
APSP -[#blue]-> Originator : The bank redirects Alice to the PISP through the callback URLs provided by the latter
end

PISP -[#blue]> Beneficiary : CreditorPaymentactivationRequestStatusReport
PISP -> Originator : confirm the credit transfer

PISP -[#blue]-> Originator : Browser of Alice is redirect to Merchant

Beneficiary -> Originator : Merchant confirms the purchase

== Bank of Alice credits Bank of Merchant (batch mode) ==

APSP -[#green]> BPSP : FIToFICustormerCreditTransfer


== Bank Notification of Merchant ==

BPSP -[#green]-> Beneficiary : BankToCustomerDebitCreditNotification
@enduml
