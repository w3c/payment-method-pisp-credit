@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments-flows/gh-pages/PaymentFlows/skin.ipml

participant "BANK B" as ASPSP2
Participant "Merchant" as Merchant
participant "PISP" as PISP
Actor "Alice" as PSU
participant "Bank A" as ASPSP1

' ASPSP, PSU, PISP come from DSP2 definitions

Title PISP initiated Credit Transfer / 16

== Previous parametrization ==

PSU -[#black]> PSU : Alice enters her account-identifier into a PISP Payment App \n or a form filler of the browser

note right PSU
IBAN is a common identifier of the Bank through European countries
end note

Merchant <[#black]-> PISP : contract with mutual authentication in place
note left PISP
Merchant could have multiple PISP depending
 of Bank reachability they provide
Merchant could have PISP for PISP credit 
transfer and acquirer for cards that are differents
end note



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

PSU -[#black]> PSU : Alice choose PISP credit Payment

PSU -[#blue]> Merchant : PaymentResponse is sent to merchant

== PISP credit transfer intiation == 

Merchant -> Merchant : Merchant identify relevant PISP (if he gots multiple)

Merchant -> PSU : Merchant redirect browser of Alice to PISP

note right PISP
this redirection is done in order to enalbe the PISP
to redirect later Alice on her Bank (see "Alice authentication" frame)
end note

group Credit Initiation (Alice see nothing on her browser)

note left PISP
the previous flow and the following should be optimised
(see issue)
end note

Merchant -[#blue]-> PISP : Merchant gives to PISP all data from Payment Request & Payment Response
note left PISP
authentication between merchant and PISP is out of scope of this document
and is organised through direct relationship depending on PISP technology
(see previous parametrization)
end note
PISP --> PISP : PISP found the URL of Bank \n of Alice using home made directory

note right PISP
It seems that a major value added of PISP is to maintain
directory of all banks in order to reach them
end note

PISP -[#blue]-> ASPSP1 : CustomerCreditTransferInitiation using the Credit initiation API of Bank of Alice
ASPSP1-[#green]-> ASPSP1 : authentication of PISP using Bank A made directory

note left ASPSP1
The bank made directory of PISP is made by concatenation
of regulated directories from European Authorities
end note

ASPSP1-[#blue]-> PISP : The Bank of Alice also provides the URL to be used for redirecting Alice browser (authentication URL)
end 

group Authentication of Alice
PISP -[#blue]-> PSU: Browser of Alice is redirect to authentication URL of Bank of Alice
ASPSP1  -[#orange]-> PSU : authentication challenge linked with amount & merchant

note left PSU
the choice of the account is done at this level
end note

PSU -[#orange]-> ASPSP1 :consent for the credit Transfer
ASPSP1 -[#green]-> ASPSP2 : Credit transfer
ASPSP1 -[#blue]-> PSU : The bank redirects Alice to the PISP through the callback URLs provided by the PISP
end

PISP -[#blue]> Merchant : CreditorPaymentactivationRequestStatusReport
Merchant -[#blue]> PISP : acknowledge the information of payment

PISP -[#blue]-> PSU : Browser of Alice is redirect to Merchant

Merchant -> PSU : Merchant confirms the purchase

== Bank of Alice credits Bank of Merchant (batch mode) ==

ASPSP1 -[#green]> ASPSP2 : FIToFICustormerCreditTransfer


== Bank Notification of Merchant ==

ASPSP2 -[#green]-> Merchant : BankToCustomerDebitCreditNotification
@enduml
