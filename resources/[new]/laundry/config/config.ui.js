// Formatar uma string de valor monetário.
function formatCurrency(value,paymentType) {
    return "R$ "+Number(parseInt(value)).toLocaleString('pt-BR');
}

// Translate
// To translate interface strings, you just need to insert at table above, following the examples:
// It's necessary match: lower/upper case, spaces, symbols, everything. Literally the completly string.
// [ "String to Translate" , "Translated String" ],
translations = [
    // [ "CRIAÇÃO DE PERSONAGEM" , "Character Creation" ],
]
