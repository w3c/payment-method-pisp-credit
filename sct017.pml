@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments-flows/gh-pages/PaymentFlows/skin.ipml

participant "BANK B" as ASPSP2
participant "PISP" as PISP
Participant "Merchant" as Merchant
Actor "Alice" as PSU
participant "Bank A" as ASPSP1

' ASPSP, PSU, PISP come from DSP2 definitions

Title Authentication before PISP initiated Credit Transfer / 17

== Previous parametrization ==

PSU -[#black]> PSU : Alice enters her account-identifier into a Payment App \n or a form filler of the browser 
PSU -[#black]> PSU : Alice enters the URL of her bank into a Payment App \n or a form filler of the browser

note right PSU
IBAN is a common identifier of the Bank through European countries
the URL is given by her bank
end note

Merchant <[#black]-> PISP : contract with mutual authentication in place
note right PISP
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
including Authentication first credit  Payment
end note
note right PSU
Browser opens payment apps that match both with 
PaymentRequest & enrolled apps of Alice
end note

PSU -[#black]> PSU : Alice choose "Authentication first credit Payment"

group Authentication of Alice

PSU -[#orange]-> ASPSP1: "Authentication first credit Payment" app connect to Bank A

note right PSU
the choice of the account is done at this level
the amount and the merchant is shown during consentment
end note

ASPSP1 <- ASPSP1 : bank controls of the availability of funds
ASPSP1 -[#orange]-> PSU : authentication token + URL for initiating credit transfer 

end

PSU -[#blue]> Merchant : PaymentResponse is sent to merchant with token + url

== PISP credit transfer intiation (Alice see nothing on her browser) == 

Merchant -> Merchant : Merchant identify relevant PISP (if he gots multiple)


Merchant -[#blue]-> PISP : Merchant gives to PISP all data from Payment Request & Payment Response



PISP -[#blue]-> ASPSP1 : CustomerCreditTransferInitiation using the token and the URL in the paymentresponse
ASPSP1-[#green]-> ASPSP1 : authentication of PISP using \n Bank A home-made directory

note left ASPSP1
The bank home-made directory of PISP is made by concatenation
of regulated directories from European Authorities
end note

ASPSP1-[#blue]-> PISP : The Bank of Alice provides a statusresponse based on the token
ASPSP1 -[#green]-> ASPSP1 : initiate the credit \n transfer into internal system

PISP -[#blue]> Merchant : CreditorPaymentactivationRequestStatusReport \n to confirm the credit transfer
Merchant -[#blue]> PISP : acknowledge the information of payment


Merchant -> PSU : Merchant confirms the purchase

== Bank of Alice credits Bank of Merchant (batch mode) ==

ASPSP1 -[#green]> ASPSP2 : FIToFICustormerCreditTransfer


== Bank Notification of Merchant ==

ASPSP2 -[#green]-> Merchant : BankToCustomerDebitCreditNotification
@enduml
