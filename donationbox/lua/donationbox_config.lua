/**************
    GENERAL
***************/
DONATIONBOX.health = 100; // How much health should donation boxes have? 0 = invincible
DONATIONBOX.minTakeAmount = 1; // What should the minimum amount of money be allowed to take from the box?
DONATIONBOX.fontSize = 16; // How large should the font on donation boxed be?

// Note: Set any of these to "" to disable the message completely
DONATIONBOX.nameText = "{USERNAME}" // What should the name text be? (Note: {USERNAME} will be replaced with the owner of the box name.)
DONATIONBOX.holdingText = "Holding: {AMOUNT}" // What should the name text be? (Note: {USERNAME} will be replaced with the owner of the box name.)

DONATIONBOX.takeMoneyText = "You took {AMOUNT}" // When a user takes the holding what should it say? (Note: {AMOUNT} will be replaced with the amount taken)
DONATIONBOX.addedMoneyText = "{AMOUNT} has been added to your donation box."; // When a user adds money what should it tell the owner of the box? (Note: {AMOUNT} will be replaced with the amount added.)
DONATIONBOX.messageTag = "DonationBox"; // What tag should all donation box message have? (Note: This will be formatted as [DonationBox] Message)
DONATIONBOX.cannotTakeText = "You cannot take money from this box!"; // What default message should be given when a user cannot withdraw the money?
DONATIONBOX.notEnoughText = "There is not enough money to be taken from the box."; // What message should be given when a user uses a box which is under the minimum amount of money?

DONATIONBOX.messageTagColor = Color(200, 150, 0); // What should the color of the message tag be?
DONATIONBOX.nameTextColor = Color(255, 255, 255); // What should the color of the name text be?
DONATIONBOX.holdingsTextColor = Color(255, 255, 255); // What should the color of the holdings text be?
DONATIONBOX.nameTextBoxColor = Color(0, 0, 0, 200); // What should the color of the box around name text be? Color(R, G, B, A)
DONATIONBOX.holdingsTextBoxColor = Color(0, 0, 0, 200); // What should the color of the box around holdings text be? Color(R, G, B, A)

DONATIONBOX.explodeOnDestroy = true; // When a donation box is destroyed should a explosion happen?
DONATIONBOX.onlyOwnerTake = true; // Should only the owner of the box be allowed to take money from the box?
DONATIONBOX.onlyOwnerPickup = true; // Should only the owner of the box be allowed to gravgun the box?

DONATIONBOX.overrideTakeList = { // A whitelist of ranks that can override the onlyOwnerTake setting, only useful if onlyOwnerTake is set to true.
	"superadmin", // This will allow superadmins to collect from anyones donation box.
}

DONATIONBOX.overridePickupList = { // A whitelist of ranks that can override the onlyOwnerPickup setting, only useful if onlyOwnerPickup is set to true.
	"superadmin", // This will allow superadmins to gravgun anyones donation box.
}

/*******************
  HIGHEST DONATION
********************/
DONATIONBOX.showHighestDonation = true; // Should the box display the highest donation?
DONATIONBOX.highestDonationText = "Highest donation: {AMOUNT}"; // If higest donation is enabled, what text should be used for displaying the highest donation?
DONATIONBOX.highestDonationTextColor = Color(255, 255, 255, 255); // If higest Donation is enabled, color should the highest Donation text be?
DONATIONBOX.highestDonationBoxColor = Color(0, 0, 0, 150); // If higest Donation is enabled, color should the box around the highest Donation text be?

/********************
   ADDING TO DARKRP
*********************
Add it just as you would other entities. Here's an example:

DarkRP.createEntity("Donation Box", {
	ent = "donation_box",
	model = "models/props/cs_militia/footlocker01_open.mdl",
	price = 500,
	max = 1,
	cmd = "buydonationbox"
})

*/

/********************
     DEVELOPERS
*********************
Multiple hooks have been provided to additions to this addon easy.
*IMPORTANT* The owner argument may be a invalid player if gamemode is anything other than DarkRP or if spawned by the q menu.

DonationBox_canTake 
- Description: Called to check wether or not a user can take money from a donation box.
- Args: Player playerUsingBox, Player ownerOfBox, Number moneyInBox, Entity theDonationBox
Example: 
(Note: This will make it so only admins can take the money if the box holdings are above 500.)

hook.Add("DonationBox_canTake", "DonationBox_canTakeExample", function(pl, owner, money, box)
	if(!pl:IsAdmin() && money > 500)then
		return false, "You must be a admin to take that much money!";
	end
end)

DonationBox_calcTotal 
- Description: Called to calculate the amount of money to give a user using a donation box.
- Args: Player playerUsingBox, Player ownerOfBox, Number moneyInBox, Entity theDonationBox
Example: 
(Note: This will make it so that admins will always recieve twice the amount of money from donation boxes.)

hook.Add("DonationBox_calcTotal", "DonationBox_calcTotalExample", function(pl, owner, amt, box)
	if(pl:IsAdmin())then
		return amt * 2;
	end
end)

DonationBox_tookMoney 
- Description: Called after a user collects the money from a donation box.
- Args: Player playerUsingBox, Number amountTook, Entity theDonationBox, Player ownerOfTheBox
Example: 
(Note: This will make a message print to console when ever someone collects money from a donation box.)

hook.Add("DonationBox_tookMoney", "DonationBox_tookMoneyExample", function(pl, amt, box, owner)
	print(pl:Nick().." took "..amt.." from a donation box!");
end)

DonationBox_canPickup
- Description: Called to check if a user can pickup a donation box with a grav gun.
- Args: Player playerPickingUpBox, Entity theDonationBox, Player ownerOfTheBox
Example: 
(Note: This will allow all admins to gravgun donation boxes.)

hook.Add("DonationBox_canPickup", "DonationBox_canPickupExample", function(pl, box, owner)
	if(pl:IsAdmin())then
		return true;
	end
end)

DonationBox_onMoneyAdded
- Description: Called when money is added to a donationbox
- Args: Entity theDonationBox, Number currentAddAmount
Example: 
(Note: This will print a message to console whenever money is added to a donation box.)

hook.Add("DonationBox_onMoneyAdded", "DonationBox_onMoneyAddedExample", function(box, amt)
	print(amt.." has been added to entity "..box);
end)

*/
