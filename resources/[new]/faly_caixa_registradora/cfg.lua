--SCRIPT ROUBO A CAIXINHA

cfg = {}

cfg.cooldownCaixinhas = 5200 --EM SEGUNDOS
cfg.tries = 20 -- NUMERO DE TENTATIVAS

cfg.minPolice = 0 --NUMERO MINIMO DE POLICIAIS PARA FAZER O ROUBO

cfg.tempoRoubo = 30000 --TEMPO DE ROUBO

cfg.reqItem = {
    index = "fenda",
    qtd = 1
}

cfg.reward = {
    item = "dollarz",-- Item que irá receber ao roubar o caixinha
    min = 1500, -- Quantidade minima daquele item
    max = 1800 , -- Quantidade maxima daquele item
}