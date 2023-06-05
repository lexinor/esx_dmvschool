ESX.RegisterServerCallback('esx_dmvschool:canYouPay', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local cash = xPlayer.getAccount("money")
	local bank = xPlayer.getAccount("bank")

	if cash.money >= Config.Prices[type] then
		xPlayer.removeAccountMoney("cash", Config.Prices[type])
		TriggerClientEvent('esx:showNotification', source, TranslateCap('you_paid', Config.Prices[type]))
		cb(true)
	elseif bank.money >= Config.Prices[type] then
		xPlayer.removeAccountMoney("bank", Config.Prices[type])
		TriggerClientEvent('esx:showNotification', source, TranslateCap('you_paid', Config.Prices[type]))
		cb(true)
	else
		cb(false)
	end
end)

AddEventHandler('esx:playerLoaded', function(source)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		TriggerClientEvent('esx_dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('esx_dmvschool:addLicense')
AddEventHandler('esx_dmvschool:addLicense', function(type)
	local source = source

	TriggerEvent('esx_license:addLicense', source, type, function()
		TriggerEvent('esx_license:getLicenses', source, function(licenses)
			TriggerClientEvent('esx_dmvschool:loadLicenses', source, licenses)
			if type ~= "dmv" then
				exports.lexinor_id:GiveFirstTimeLicense("driving", source)
			end
		end)
	end)
end)

