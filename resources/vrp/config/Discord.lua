-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDS
-----------------------------------------------------------------------------------------------------------------------------------------
Discords = {
	["Connect"] = "https://discord.com/api/webhooks/1296130384634974289/F2aPl2k3L9WhDcFP01YUChPxoJL7YoLcFMxjvBv1ohQlF9-RY4a1jDz3pSWKMvobJtC8",
	["Disconnect"] = "https://discord.com/api/webhooks/1296130453987790929/la7PzDwE_yMUXhyLlFvcG6zJbmCD16DlQpJ4PAUBk3hYGJ813sN-FXlvIiDHJ90L1pJZ",
	["Airport"] = "",
	["Deaths"] = "https://discord.com/api/webhooks/1296130674163581009/KZkXx5mF_Dap4turoUA-hMAqvrYuVhTxRPnPegPoBA0S5z6uzjsRCBlzgXjVZPueCy9Y",
	["Police"] = "https://discord.com/api/webhooks/1296130783748296735/vY5t8r4mFdHt0juDIZBee4Yknl4kUmMqu9w0tnLIP7Sj7IlD6_QfkrOiXhswnYnF_LHP",
	["Paramedic"] = "https://discord.com/api/webhooks/1296122566502645800/21urBKtYj1Sg_PRlGrGUoco8B1OgU72xDonqG23TewMgigFf9fMEeR2bmt6DcY5C12tr",
	["Gemstone"] = "https://discord.com/api/webhooks/1296130990409781320/QoTG3fntjfED5_nVDGssjjEcwduB2OCNpNDfEZDShBVczHjQs1axQC1xYXFGce0wLDxj",
	["Login"] = "https://discord.com/api/webhooks/1128710102338252923/jwM0J_iRbwAONUSPXAQyAXHdabqYr2KIEWHPMbUwrKCZwzn0bsgCCAnAzmkSV6EcHmQf",
	["bau-casa-colocou"] = "https://discord.com/api/webhooks/1296131333457707088/lIOKgYAquY2gj4hM2bsu8AIaXDu_RJaqMnRKZW_z5GSgfyT2q5N5GPDWSgex8rV4ih7R",
	["bau-casa-tirou"] = "https://discord.com/api/webhooks/1296131433970143324/aRtQ8HMtFtZzzLM24mLU4KlMkgdwEQPwmREpH7oDHtFCRz59ognO9m1cmXT8k-5_cOaC",
	["bvida"] = "https://discord.com/api/webhooks/1155795617377947668/WsxcX9tmomcvn_8C41__kFye6jJlOJHn-zjHMsX-p9gRGsvFjM3o7FfykUmVZM9sqo6g",

	["wl"] = "https://discord.com/api/webhooks/1362534111037624552/t6lQaNxRB9N6Bd3_lQkWrSnfsH-hoX1ZA02sa25haRbl4lS-QYfc_xE82TUoN58qa2AK",
	["unwl"] = "https://discord.com/api/webhooks/1362534191731839129/mNzrlwSm_yd-IObDmppbCU-pWdoradVSIq7WhYvXNc7D1jXxlgIKYNJMTMwuunWEHkyp",
	["remcar"] = "https://discord.com/api/webhooks/1362534281334755491/agjJ1HYoTL6THuFCf2AkEKYB697j0rPTMh3VGuNeXD8kRpNABi-DQmPv-eGnd03oHFYh",


	["group"] = "https://discord.com/api/webhooks/1296159862106882098/j5xwAWYCk67lVCmtifsUyxQ13vboxGJYcczNTrrPvhwJkxSrEGFd5PTXcab_jkC9u-hi",
	["ungroup"] = "https://discord.com/api/webhooks/1296159947201056779/6eMJsr8tRN6e7UY_kc-Hg7MVxOFsoTxoJWaNpYVu9J9yEVKjF931uUUoCOm59ewYOMXe",
	["dv"] = "https://discord.com/api/webhooks/1296159755156459550/6hAOv1vI5w46SFnxZLwetWDffqnW3pkJusGiasdpzlKMQhgH9PJyRb5bA2CaUQ3rj6BM"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Discord",function(Hook,Message,Color)
	PerformHttpRequest(Discords[Hook],function(err,text,headers) end,"POST",json.encode({
		username = ServerName,
		embeds = { { color = Color, description = Message } }
	}),{ ["Content-Type"] = "application/json" })
end)

