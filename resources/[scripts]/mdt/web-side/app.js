// Variáveis globais
let currentUser = null;
let isInService = false;
let currentSection = 'dashboard';
let isLoggedIn = false;
let userDepartment = null;
let userRank = null;

// Configuração das senhas dos departamentos
const departmentPasswords = {
    'Police': 'pm123',
    'Pcivil': 'pc123', 
    'Core': 'core123',
    'PRF': 'prf123'
};

// Mapeamento de grupos para nomes de departamento
const departmentNames = {
    'Police': 'Polícia Militar',
    'Pcivil': 'Polícia Civil',
    'Core': 'CORE',
    'PRF': 'PRF'
};

// Inicialização
$(document).ready(function() {
    initializeApp();
    setupEventListeners();
});

// Inicializar aplicação
function initializeApp() {
    // MDT permanece fechado por padrão
    // Modal de login só aparece quando o MDT for aberto
    hideLoginModal();
}

// Configurar event listeners
function setupEventListeners() {
    // Login
    $('#loginForm').on('submit', handleLogin);
    
    // Fechar modal de login clicando fora
    $('#loginModal').on('click', function(e) {
        if (e.target === this) {
            closeMDT(); // Fechar MDT se clicar fora do modal
        }
    });
    
    // Logout
    $('#logoutBtn').on('click', handleLogout);
    
    // Fechar MDT
    $('#closeBtn').on('click', closeMDT);
    
    // Navegação
    $('.nav-item').on('click', handleNavigation);
    
    // Service toggle (now LOG OUT)
    $('#serviceToggle').on('click', handleLogout);
    
    // Dashboard
    $('#addAnnouncementBtn').on('click', showAddAnnouncementModal);
    
    // Search
    $('#searchBtn').on('click', performSearch);
    $('#searchPassport').on('keypress', function(e) {
        if (e.which === 13) performSearch();
    });
    
    // Forms
    $('#fineForm').on('submit', handleFineSubmit);
    $('#prisonFineForm').on('submit', handlePrisonFineSubmit);
    
    // Section buttons
    $('#addWarrantBtn').on('click', showAddWarrantModal);
    $('#addPortBtn').on('click', showAddPortModal);
    $('#addReportBtn').on('click', showAddReportModal);
    $('#addVehicleBtn').on('click', showAddVehicleModal);
    $('#addAnnouncementSectionBtn').on('click', showAddAnnouncementModal);
    $('#openPenalCodeBtn').on('click', showPenalCodeModal);
    $('#openPrisonPenalCodeBtn').on('click', showPrisonPenalCodeModal);
    
    // Modal
    $('#modalClose').on('click', closeModal);
    $('#modalOverlay').on('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });
    
    // Fechar MDT clicando no overlay
    $('#mdtOverlay').on('click', function(e) {
        if (e.target === this) {
            closeMDT();
        }
    });
    
    // NUI Callbacks
    window.addEventListener('message', handleNUIMessage);
    
    // Setup fines list listeners
    setupFinesListListeners();
}

// NUI Message Handler
function handleNUIMessage(event) {
    const data = event.data;
    
    switch (data.action) {
        case 'openMDT':
            if (isLoggedIn) {
                showMDTInterface();
            } else {
                showLoginModal();
            }
            break;
        case 'closeMDT':
            closeMDT();
            break;
    }
}

// Sistema de Login
function showLoginModal() {
    // Garantir que o overlay não está visível durante o login
    $('#mdtOverlay').hide();
    $('#mdtInterface').hide();
    $('#loginModal').css('display', 'flex');
    $('#passport').focus();
    hideLoginError();
}

function hideLoginModal() {
    console.log('hideLoginModal chamado');
    $('#loginModal').css('display', 'none');
    console.log('Modal de login escondido');
}

function showLoginError(message) {
    $('#errorMessage').text(message);
    $('#loginError').show();
}

function hideLoginError() {
    $('#loginError').hide();
}

function handleLogin(e) {
    e.preventDefault();
    
    const passport = $('#passport').val().trim();
    const password = $('#password').val().trim();
    
    // Validação básica
    if (!passport || !password) {
        showLoginError('Por favor, preencha todos os campos.');
        return;
    }
    
    // Verificar se o passaporte é numérico
    if (!/^\d+$/.test(passport)) {
        showLoginError('O passaporte deve conter apenas números.');
        return;
    }
    
    // Verificar se a senha corresponde a algum departamento
    let validDepartment = null;
    for (const [group, pass] of Object.entries(departmentPasswords)) {
        if (pass === password) {
            validDepartment = group;
            break;
        }
    }
    
    if (!validDepartment) {
        showLoginError('Senha do departamento incorreta.');
        return;
    }
    
    // Tentar autenticar o usuário
    authenticateUser(passport, validDepartment);
}

function authenticateUser(passport, department) {
    console.log('authenticateUser chamado com:', { passport, department });
    
    // Mostrar loading no botão
    const loginBtn = $('.login-btn');
    const originalText = loginBtn.html();
    loginBtn.html('<i class="fas fa-spinner fa-spin"></i> Autenticando...');
    loginBtn.prop('disabled', true);
    
    console.log('Enviando requisição para o servidor...');
    
    // Chamar servidor para verificar se o usuário existe e tem permissão
    $.post('https://mdt/authenticateUser', JSON.stringify({
        passport: passport,
        department: department
    }), function(response) {
        console.log('Resposta recebida do servidor:', response);
        
        if (response.success) {
            console.log('Login bem-sucedido, dados do usuário:', response.user);
            
            // Login bem-sucedido
            currentUser = response.user;
            userDepartment = department;
            userRank = response.user.rank || 'Oficial';
            isLoggedIn = true;
            
            console.log('Escondendo modal de login...');
            // Esconder modal de login
            hideLoginModal();
            
            console.log('Mostrando interface MDT...');
            // Mostrar MDT
            showMDTInterface();
            
            console.log('Atualizando informações do usuário...');
            // Atualizar informações do usuário
            updateUserInfo();
            
            // Mostrar notificação de sucesso
            showNotification(`Bem-vindo, ${currentUser.name}!`, 'success');
            
        } else {
            console.log('Login falhou:', response.message);
            // Login falhou
            showLoginError(response.message || 'Erro na autenticação. Verifique suas credenciais.');
        }
    }).fail(function(xhr, status, error) {
        console.log('Erro na requisição:', { xhr, status, error });
        showLoginError('Erro de conexão. Tente novamente.');
    }).always(function() {
        console.log('Restaurando botão de login...');
        // Restaurar botão
        loginBtn.html(originalText);
        loginBtn.prop('disabled', false);
    });
}

function handleLogout() {
    // Limpar dados do usuário
    currentUser = null;
    userDepartment = null;
    userRank = null;
    isLoggedIn = false;
    isInService = false;
    
    // Fechar MDT
    closeMDT();
    
    // Limpar formulário
    $('#loginForm')[0].reset();
    hideLoginError();
    
    showNotification('Logout realizado com sucesso.', 'info');
}

// Obter status de serviço atual
function getServiceStatus() {
    $.post('https://mdt/getServiceStatus', JSON.stringify({}), function(response) {
        if (response.success) {
            isInService = response.inService;
            updateServiceStatus();
        }
    });
}

// Navegação
function handleNavigation() {
    const section = $(this).data('section');
    
    $('.nav-item').removeClass('active');
    $(this).addClass('active');
    
    $('.content-section').removeClass('active');
    $(`#${section}Section`).addClass('active');
    
    currentSection = section;
    updatePageTitle();
    
    // Carregar dados específicos da seção
    switch (section) {
        case 'dashboard':
            loadDashboardData();
            break;
        case 'warrants':
            loadWarrants();
            break;
        case 'ports':
            loadPorts();
            break;
        case 'reports':
            loadReports();
            break;
        case 'vehicles':
            loadVehicles();
            break;
        case 'announcements':
            loadAnnouncements();
            break;
    }
}

// Mostrar interface do MDT
function showMDTInterface() {
    console.log('showMDTInterface chamado');
    
    // $('#loginScreen').hide(); // Login temporariamente desabilitado
    $('#mdtOverlay').show();
    $('#mdtInterface').show();
    
    console.log('MDT interface mostrada');
    
    updateUserInfo();
    getServiceStatus();
    updatePageTitle();
    loadDashboardData(); // Carregar dados do dashboard automaticamente
    
    console.log('showMDTInterface concluído');
}

// Mostrar tela de login
function showLoginScreen() {
    $('#mdtInterface').hide();
    $('#mdtOverlay').hide();
    $('#loginScreen').show();
    $('#loginForm')[0].reset();
}

// Fechar MDT
function closeMDT() {
    $('#mdtInterface').hide();
    $('#mdtOverlay').hide();
    hideLoginModal(); // Esconder modal de login também
    $.post('https://mdt/closeMDT', JSON.stringify({}));
}

// Atualizar informações do usuário
function updateUserInfo() {
    if (currentUser && isLoggedIn) {
        // Usar dados do usuário logado
        $('#userName').text(currentUser.name || 'Nome do Oficial');
        $('#userRank').text(userRank || 'Patente');
        
        // Adicionar informação do departamento se disponível
        if (userDepartment && departmentNames[userDepartment]) {
            $('#userRank').text(`${userRank} - ${departmentNames[userDepartment]}`);
        }
    } else {
        // Buscar informações do usuário atual (fallback)
        $.post('https://mdt/getUserInfo', JSON.stringify({}), function(response) {
            if (response.success) {
                $('#userName').text(response.user.name || 'Nome do Oficial');
                $('#userRank').text(response.user.rank || 'Patente');
            } else {
                $('#userName').text('Nome do Oficial');
                $('#userRank').text('Patente');
            }
        }).fail(function() {
            $('#userName').text('Nome do Oficial');
            $('#userRank').text('Patente');
        });
    }
}

// Atualizar status de serviço
function updateServiceStatus() {
    const statusDot = $('#serviceStatus .status-dot');
    const statusText = $('#serviceStatus .status-text');
    
    if (isInService) {
        statusDot.removeClass('offline').addClass('online');
        statusText.text('Em Serviço');
    } else {
        statusDot.removeClass('online').addClass('offline');
        statusText.text('Fora de Serviço');
    }
}

// Atualizar título da página
function updatePageTitle() {
    const titles = {
        'dashboard': 'Dashboard',
        'search': 'Buscar Cidadão',
        'prison': 'Registrar Prisão',
        'fine': 'Aplicar Multa',
        'warrants': 'Mandados de Busca',
        'ports': 'Portes de Armas',
        'reports': 'Relatórios',
        'vehicles': 'Veículos Apreendidos',
        'announcements': 'Gerenciar Avisos'
    };
    
    $('#pageTitle').text(titles[currentSection] || 'Dashboard');
}

// Carregar dados do dashboard
function loadDashboardData() {
    // Carregar estatísticas
    $.post('https://mdt/getDashboardStats', JSON.stringify({}), function(response) {
        if (response.result) {
            $('#prisonCount').text(response.result.prisons);
            $('#fineCount').text(response.result.fines);
            $('#warrantCount').text(response.result.warrants);
            $('#vehicleCount').text(response.result.vehicles);
        }
    });
    
    // Carregar avisos
    loadAnnouncements();
}

// Buscar usuário
function performSearch() {
    const passport = $('#searchPassport').val();
    
    if (!passport) {
        showNotification('Por favor, digite o ID do cidadão.', 'error');
        return;
    }
    
    $('#searchResults').html('<div class="loading"><div class="spinner"></div></div>');
    
    $.post('https://mdt/searchUser', JSON.stringify({
        passport: passport
    }), function(response) {
        if (response.result) {
            displaySearchResults(response.result);
        } else {
            $('#searchResults').html('<div class="no-results"><i class="fas fa-user-slash" style="font-size: 48px; color: #95a5a6; margin-bottom: 15px;"></i><p>Cidadão não encontrado na base de dados.</p><p style="font-size: 12px; color: #7f8c8d;">Verifique se o ID está correto.</p></div>');
        }
    });
}

// Exibir resultados da busca
function displaySearchResults(data) {
    const user = data.user;
    const prisonRecords = data.prisonRecords || [];
    const warrants = data.warrants || [];
    const fines = data.fines || [];
    
    let html = `
        <div class="user-card">
            <div class="user-header">
                <h3>${user.name}</h3>
                <span class="passport">Passaporte: ${user.passport}</span>
            </div>
            <div class="user-details">
                <p><strong>Telefone:</strong> ${user.phone || 'N/A'}</p>
                <p><strong>Email:</strong> ${user.email || 'N/A'}</p>
                <p><strong>Multas em Débito:</strong> <span class="fines-total">$${user.totalFines || 0}</span> (${user.finesCount || 0} multas)</p>
                <button class="view-records-btn" onclick="showCitizenRecords(${user.passport}, '${user.name}')">
                    <i class="fas fa-history"></i> Ver Registros Completos
                </button>
            </div>
        </div>
    `;
    
    if (prisonRecords.length > 0) {
        html += `
            <div class="records-section">
                <h4>Histórico de Prisões</h4>
                <div class="records-list">
        `;
        
        prisonRecords.forEach(record => {
            html += `
                <div class="record-item">
                    <p><strong>Data:</strong> ${record.date}</p>
                    <p><strong>Serviços:</strong> ${record.services}</p>
                    <p><strong>Multas:</strong> $${record.fines}</p>
                    <p><strong>Observações:</strong> ${record.text || 'N/A'}</p>
                </div>
            `;
        });
        
        html += '</div></div>';
    }
    
    if (fines.length > 0) {
        html += `
            <div class="fines-section">
                <h4>Multas em Débito</h4>
                <div class="fines-list">
        `;
        
        fines.forEach(fine => {
            html += `
                <div class="fine-item">
                    <p><strong>Valor:</strong> $${fine.Value || 0}</p>
                    <p><strong>Data:</strong> ${fine.Date || 'N/A'}</p>
                    <p><strong>Hora:</strong> ${fine.Hour || 'N/A'}</p>
                    <p><strong>Motivo:</strong> ${fine.Message || 'N/A'}</p>
                </div>
            `;
        });
        
        html += '</div></div>';
    }
    
    if (warrants.length > 0) {
        html += `
            <div class="warrants-section">
                <h4>Mandados Ativos</h4>
                <div class="warrants-list">
        `;
        
        warrants.forEach(warrant => {
            html += `
                <div class="warrant-item">
                    <p><strong>Motivo:</strong> ${warrant.reason}</p>
                    <p><strong>Data:</strong> ${warrant.timeStamp}</p>
                </div>
            `;
        });
        
        html += '</div></div>';
    }
    
    $('#searchResults').html(html);
}



// Multa
function handleFineSubmit(e) {
    e.preventDefault();
    
    const data = {
        passport: $('#finePassport').val(),
        fines: $('#fineAmount').val(),
        text: $('#fineText').val(),
        license: $('#fineLicense').val(),
        article: $('#fineArticle').val(),
        infraction: $('#fineInfraction').val(),
        description: $('#fineDescription').val()
    };
    
    if (!data.passport || !data.fines || !data.article || !data.infraction) {
        showNotification('Por favor, selecione uma infração do código penal e preencha o passaporte.', 'error');
        return;
    }
    
    $.post('https://mdt/initFine', JSON.stringify(data));
    $('#fineForm')[0].reset();
    showNotification('Multa aplicada com sucesso!', 'success');
}

function handlePrisonFineSubmit(e) {
    e.preventDefault();
    
    const data = {
        passport: $('#prisonFinePassport').val(),
        fines: $('#prisonFineAmount').val(),
        text: $('#prisonFineObservations').val(),
        license: $('#prisonFineObservations').val(),
        article: $('#prisonFineArticle').val(),
        infraction: $('#prisonFineInfraction').val(),
        description: $('#prisonFineDescription').val(),
        prisonTime: $('#prisonFinePrisonTime').val()
    };
    
    if (!data.passport || !data.fines || !data.article || !data.infraction || !data.prisonTime) {
        showNotification('Por favor, selecione uma infração do código penal e preencha o passaporte.', 'error');
        return;
    }
    
    $.post('https://mdt/initPrisonFine', JSON.stringify(data));
    $('#prisonFineForm')[0].reset();
    showNotification('Multa com prisão aplicada com sucesso!', 'success');
}

// Carregar mandados
function loadWarrants() {
    $.post('https://mdt/getWarrants', JSON.stringify({}), function(response) {
        if (response.result) {
            displayWarrants(response.result);
        }
    });
}

// Exibir mandados
function displayWarrants(warrants) {
    let html = '';
    
    if (warrants.length === 0) {
        html = '<p class="no-data">Nenhum mandado encontrado.</p>';
    } else {
        warrants.forEach(warrant => {
            html += `
                <div class="warrant-card">
                    <div class="warrant-header">
                        <h4>${warrant.identity}</h4>
                        <button class="delete-btn" onclick="deleteWarrant(${warrant.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                    <p><strong>Motivo:</strong> ${warrant.reason}</p>
                    <p><strong>Data:</strong> ${warrant.timeStamp}</p>
                    <p><strong>Status:</strong> ${warrant.status}</p>
                </div>
            `;
        });
    }
    
    $('#warrantsList').html(html);
}

// Deletar mandado
function deleteWarrant(id) {
    showConfirmModal(
        'Confirmar Remoção',
        'Tem certeza que deseja remover este mandado?',
        function() {
            $.post('https://mdt/deleteWarrant', JSON.stringify({ id: id }));
            loadWarrants();
            showNotification('Mandado removido com sucesso!', 'success');
        }
    );
}

// Carregar portes
function loadPorts() {
    $.post('https://mdt/searchPort', JSON.stringify({ type: 'consultar' }), function(response) {
        if (response.result) {
            displayPorts(response.result);
        }
    });
}

// Exibir portes
function displayPorts(ports) {
    let html = '';
    
    if (ports.length === 0) {
        html = '<p class="no-data">Nenhum porte encontrado.</p>';
    } else {
        ports.forEach(port => {
            html += `
                <div class="port-card">
                    <div class="port-header">
                        <h4>${port.identity}</h4>
                        <div class="port-actions">
                            <button class="edit-btn" onclick="editPort(${port.portId})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="delete-btn" onclick="deletePort(${port.portId})">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                    <p><strong>Serial:</strong> ${port.serial}</p>
                    <p><strong>Data:</strong> ${port.date}</p>
                    <p><strong>Exame:</strong> ${port.exam || 'N/A'}</p>
                </div>
            `;
        });
    }
    
    $('#portsList').html(html);
}

// Carregar relatórios
function loadReports() {
    $.post('https://mdt/getReports', JSON.stringify({}), function(response) {
        if (response.result) {
            displayReports(response.result);
        }
    });
}

// Exibir relatórios
function displayReports(reports) {
    let html = '';
    
    if (reports.length === 0) {
        html = '<p class="no-data">Nenhum relatório encontrado.</p>';
    } else {
        reports.forEach(report => {
            // Escapar caracteres especiais para evitar problemas com JavaScript
            const escapedVictimName = (report.victim_name || 'Não informado').replace(/'/g, "\\'").replace(/"/g, '\\"');
            const escapedPoliceName = (report.police_name || 'Não informado').replace(/'/g, "\\'").replace(/"/g, '\\"');
            const escapedReport = (report.victim_report || '').replace(/'/g, "\\'").replace(/"/g, '\\"').replace(/\n/g, '\\n');
            
            // Criar título baseado no conteúdo do relatório
            let reportTitle = 'Relatório';
            if (report.victim_report && report.victim_report.trim && report.victim_report.trim()) {
                // Pegar as primeiras palavras do relatório como título
                const words = report.victim_report.trim().split(/\s+/);
                if (words.length > 0) {
                    // Pegar até 5 palavras para o título
                    reportTitle = words.slice(0, 5).join(' ');
                    if (reportTitle.length > 50) {
                        reportTitle = reportTitle.substring(0, 50) + '...';
                    }
                }
            }
            
            html += `
                <div class="report-card" data-report-id="${report.id}" data-victim-name="${escapedVictimName}" data-police-name="${escapedPoliceName}" data-report-content="${escapedReport}" data-created-at="${report.created_at}" data-solved="${report.solved}">
                    <div class="report-header">
                        <h4>${reportTitle}</h4>
                        <div class="report-actions">
                            <button class="solve-btn" onclick="event.stopPropagation(); solveReport(${report.id})">
                                <i class="fas fa-check"></i>
                            </button>
                            <button class="delete-btn" onclick="event.stopPropagation(); deleteReport(${report.id})">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                    <div class="report-meta">
                        <p><strong>Data:</strong> ${report.created_at}</p>
                        <p><strong>Status:</strong> ${report.solved === '1' ? 'Resolvido' : 'Pendente'}</p>
                    </div>
                    <div class="report-click-hint">
                        <i class="fas fa-eye"></i> Clique para ver detalhes
                    </div>
                </div>
            `;
        });
    }
    
    $('#reportsList').html(html);
    
    // Adicionar event listeners para os report cards
    $('.report-card').off('click').on('click', function() {
        const $card = $(this);
        const reportId = $card.data('report-id');
        
        // Buscar dados atualizados do servidor
        $.post('https://mdt/getReportById', JSON.stringify({ id: reportId }), function(response) {
            if (response.result) {
                const report = response.result;
                showReportDetails(
                    report.id,
                    report.victim_name,
                    report.police_name || 'Não informado',
                    report.victim_report,
                    report.created_at,
                    report.solved
                );
            }
        });
    });
}

// Mostrar detalhes do relatório
function showReportDetails(id, victimName, officerName, reportContent, createdAt, solved) {
    const status = solved === '1' ? 'Resolvido' : 'Pendente';
    const statusClass = solved === '1' ? 'status-resolved' : 'status-pending';
    
    // Extrair apenas a descrição original do relatório, removendo as informações do oficial
    let cleanReportContent = reportContent;
    const officerInfoPattern = /\n\n---\nOficial:.*/s;
    const match = reportContent.match(officerInfoPattern);
    if (match) {
        cleanReportContent = reportContent.replace(officerInfoPattern, '').trim();
    }
    
    const modalContent = `
        <div class="report-details">
            <div class="detail-section">
                <h3>Informações Gerais</h3>
                <div class="detail-grid">
                    <div class="detail-item">
                        <strong>ID do Relatório:</strong> ${id}
                    </div>
                    <div class="detail-item">
                        <strong>Vítima:</strong> ${victimName}
                    </div>
                    <div class="detail-item">
                        <strong>Oficial Responsável:</strong> ${officerName}
                    </div>
                    <div class="detail-item">
                        <strong>Data de Criação:</strong> ${createdAt}
                    </div>
                    <div class="detail-item">
                        <strong>Status:</strong> <span class="${statusClass}">${status}</span>
                    </div>
                </div>
            </div>
            
            <div class="detail-section">
                <h3>Conteúdo do Relatório</h3>
                <div class="report-content">
                    ${cleanReportContent.replace(/\n/g, '<br>')}
                </div>
            </div>
            
            <div class="detail-actions">
                <button class="action-btn solve-btn" id="solveReportBtn" data-report-id="${id}">
                    <i class="fas fa-check"></i> Marcar como Resolvido
                </button>
                <button class="action-btn delete-btn" id="deleteReportBtn" data-report-id="${id}">
                    <i class="fas fa-trash"></i> Excluir Relatório
                </button>
            </div>
        </div>
    `;
    
    showModal('Detalhes do Relatório', modalContent);
    
    // Adicionar event listeners para os botões do modal
    $('#solveReportBtn').off('click').on('click', function() {
        const reportId = $(this).data('report-id');
        solveReport(reportId);
        closeModal();
    });
    
    $('#deleteReportBtn').off('click').on('click', function() {
        const reportId = $(this).data('report-id');
        deleteReport(parseInt(reportId));
        closeModal();
    });
}

// Carregar veículos
function loadVehicles() {
    $.post('https://mdt/getImpoundedVehicles', JSON.stringify({}), function(response) {
        if (response.result) {
            displayVehicles(response.result);
        }
    });
}

// Exibir veículos
function displayVehicles(vehicles) {
    let html = '';
    
    if (vehicles.length === 0) {
        html = '<p class="no-data">Nenhum veículo apreendido.</p>';
    } else {
        vehicles.forEach(vehicle => {
            html += `
                <div class="vehicle-card">
                    <div class="vehicle-header">
                        <h4>${vehicle.plate}</h4>
                        <button class="release-btn" onclick="releaseVehicle('${vehicle.plate}')">
                            <i class="fas fa-unlock"></i>
                        </button>
                    </div>
                    <p><strong>Modelo:</strong> ${vehicle.model}</p>
                    <p><strong>Motivo:</strong> ${vehicle.reason}</p>
                    <p><strong>Oficial:</strong> ${vehicle.officer}</p>
                    <p><strong>Data:</strong> ${vehicle.impounded_at}</p>
                </div>
            `;
        });
    }
    
    $('#vehiclesList').html(html);
}

// Carregar avisos
function loadAnnouncements() {
    $.post('https://mdt/getAnnouncements', JSON.stringify({}), function(response) {
        if (response.result) {
            displayAnnouncements(response.result);
        }
    });
}

// Exibir avisos
function displayAnnouncements(announcements) {
    let html = '';
    
    if (announcements.length === 0) {
        html = '<p class="no-data">Nenhum aviso encontrado.</p>';
    } else {
        announcements.forEach(announcement => {
            html += `
                <div class="announcement-card">
                    <div class="announcement-header">
                        <h4>${announcement.title}</h4>
                        <div class="announcement-actions">
                            <button class="delete-btn" onclick="deleteAnnouncement(${announcement.id})">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                    <p>${announcement.content}</p>
                    <div class="announcement-footer">
                        <span><strong>Autor:</strong> ${announcement.author}</span>
                        <span><strong>Data:</strong> ${announcement.created_at}</span>
                    </div>
                </div>
            `;
        });
    }
    
    if (currentSection === 'dashboard') {
        $('#announcementsList').html(html);
    } else {
        $('#announcementsManagement').html(html);
    }
}

// Modais
function showAddAnnouncementModal() {
    showModal('Novo Aviso', `
        <form id="announcementForm">
            <div class="form-group">
                <label>Título</label>
                <input type="text" id="announcementTitle" required>
            </div>
            <div class="form-group">
                <label>Conteúdo</label>
                <textarea id="announcementContent" rows="4" required></textarea>
            </div>
            <button type="submit" class="submit-btn">
                <i class="fas fa-plus"></i>
                Publicar Aviso
            </button>
        </form>
    `);
    
    $('#announcementForm').on('submit', function(e) {
        e.preventDefault();
        
        if (!isLoggedIn || !currentUser) {
            showNotification('Você precisa estar logado para publicar avisos.', 'error');
            return;
        }
        
        const data = {
            title: $('#announcementTitle').val(),
            content: $('#announcementContent').val(),
            author: currentUser.name,
            department: userDepartment,
            rank: userRank
        };
        
        $.post('https://mdt/addAnnouncement', JSON.stringify(data));
        closeModal();
        loadAnnouncements();
        showNotification('Aviso publicado com sucesso!', 'success');
    });
}

function showAddWarrantModal() {
    showModal('Novo Mandado', `
        <form id="warrantForm">
            <div class="form-group">
                <label>Passaporte</label>
                <input type="number" id="warrantPassport" required>
            </div>
            <div class="form-group">
                <label>Motivo</label>
                <textarea id="warrantReason" rows="4" required></textarea>
            </div>
            <button type="submit" class="submit-btn">
                <i class="fas fa-plus"></i>
                Criar Mandado
            </button>
        </form>
    `);
    
    $('#warrantForm').on('submit', function(e) {
        e.preventDefault();
        
        const data = {
            passport: $('#warrantPassport').val(),
            text: $('#warrantReason').val()
        };
        
        $.post('https://mdt/setWarrant', JSON.stringify(data));
        closeModal();
        loadWarrants();
        showNotification('Mandado criado com sucesso!', 'success');
    });
}

function showAddPortModal() {
    showModal('Novo Porte', `
        <form id="portForm">
            <div class="form-group">
                <label>Passaporte</label>
                <input type="number" id="portPassport" required>
            </div>
            <div class="form-group">
                <label>Serial</label>
                <input type="text" id="portSerial" required>
            </div>
            <div class="form-group">
                <label>Status</label>
                <input type="text" id="portStatus" required>
            </div>
            <div class="form-group">
                <label>Exame</label>
                <input type="text" id="portExam">
            </div>
            <button type="submit" class="submit-btn">
                <i class="fas fa-plus"></i>
                Criar Porte
            </button>
        </form>
    `);
    
    $('#portForm').on('submit', function(e) {
        e.preventDefault();
        
        const data = {
            passport: $('#portPassport').val(),
            serial: $('#portSerial').val(),
            status: $('#portStatus').val(),
            exam: $('#portExam').val()
        };
        
        $.post('https://mdt/givePort', JSON.stringify(data));
        closeModal();
        loadPorts();
        showNotification('Porte criado com sucesso!', 'success');
    });
}

function showAddReportModal() {
    showModal('Novo Relatório', `
        <form id="reportForm">
            <div class="form-group">
                <label>ID da Vítima</label>
                <input type="number" id="reportVictimId" required>
            </div>
            <div class="form-group">
                <label>Nome da Vítima</label>
                <input type="text" id="reportVictimName" required>
            </div>
            <div class="form-group">
                <label>Oficial Responsável</label>
                <input type="text" id="reportOfficerName" placeholder="Ex: Comandante - Jáco Tomal" required>
            </div>
            <div class="form-group">
                <label>Relatório</label>
                <textarea id="reportContent" rows="4" required></textarea>
            </div>
            <button type="submit" class="submit-btn">
                <i class="fas fa-plus"></i>
                Criar Relatório
            </button>
        </form>
    `);
    
    $('#reportForm').on('submit', function(e) {
        e.preventDefault();
        
        if (!isLoggedIn || !currentUser) {
            showNotification('Você precisa estar logado para criar relatórios.', 'error');
            return;
        }
        
        const data = {
            victim_id: $('#reportVictimId').val(),
            victim_name: $('#reportVictimName').val(),
            victim_report: $('#reportContent').val(),
            officer_name: $('#reportOfficerName').val(),
            department: userDepartment,
            rank: userRank
        };
        
        $.post('https://mdt/insertReport', JSON.stringify(data), function(response) {
            closeModal();
            loadReports();
            showNotification('Relatório criado com sucesso!', 'success');
        });
    });
}

function showAddVehicleModal() {
    showModal('Apreender Veículo', `
        <form id="vehicleForm">
            <div class="form-group">
                <label>Placa</label>
                <input type="text" id="vehiclePlate" required>
            </div>
            <div class="form-group">
                <label>Motivo</label>
                <textarea id="vehicleReason" rows="4" required></textarea>
            </div>
            <button type="submit" class="submit-btn">
                <i class="fas fa-plus"></i>
                Apreender Veículo
            </button>
        </form>
    `);
    
    $('#vehicleForm').on('submit', function(e) {
        e.preventDefault();
        
        const data = {
            plate: $('#vehiclePlate').val(),
            reason: $('#vehicleReason').val()
        };
        
        $.post('https://mdt/impoundVehicle', JSON.stringify(data));
        closeModal();
        loadVehicles();
        showNotification('Veículo apreendido com sucesso!', 'success');
    });
}

// Mostrar modal
function showModal(title, content) {
    $('#modalTitle').text(title);
    $('#modalContent').html(content);
    $('#modalOverlay').show();
    
    // Garantir que o modal apareça corretamente
    $('#modalOverlay').css({
        'display': 'flex',
        'z-index': '99999',
        'position': 'fixed'
    });
}

// Fechar modal
function closeModal() {
    $('#modalOverlay').hide();
    $('#modalContent').empty();
}

// Funções auxiliares
function deletePort(id) {
    showConfirmModal(
        'Confirmar Remoção',
        'Tem certeza que deseja remover este porte?',
        function() {
            $.post('https://mdt/deletePort', JSON.stringify({ id: id }));
            loadPorts();
            showNotification('Porte removido com sucesso!', 'success');
        }
    );
}

function solveReport(id) {
    $.post('https://mdt/setReportSolved', JSON.stringify({ id: id }), function(response) {
        loadReports();
        showNotification('Relatório marcado como resolvido!', 'success');
    });
}

function deleteReport(id) {
    showConfirmModal(
        'Confirmar Remoção',
        'Tem certeza que deseja remover este relatório?',
        function() {
            $.post('https://mdt/deleteReport', JSON.stringify({ id: id }), function(response) {
                loadReports();
                showNotification('Relatório removido com sucesso!', 'success');
            });
        }
    );
}

function releaseVehicle(plate) {
    showConfirmModal(
        'Confirmar Liberação',
        'Tem certeza que deseja liberar este veículo?',
        function() {
            $.post('https://mdt/releaseVehicle', JSON.stringify({ plate: plate }));
            loadVehicles();
            showNotification('Veículo liberado com sucesso!', 'success');
        }
    );
}

function deleteAnnouncement(id) {
    showConfirmModal(
        'Confirmar Remoção',
        'Tem certeza que deseja remover este aviso?',
        function() {
            $.post('https://mdt/deleteAnnouncement', JSON.stringify({ id: id }));
            loadAnnouncements();
            showNotification('Aviso removido com sucesso!', 'success');
        }
    );
}

// Modal de confirmação customizado
function showConfirmModal(title, message, onConfirm) {
    // Usar o modal dedicado de confirmação
    $('#confirmModalTitle').text(title);
    $('#confirmModalMessage').text(message);
    $('#confirmModal').show();
    
    // Garantir que o modal apareça corretamente
    $('#confirmModal').css({
        'display': 'flex',
        'z-index': '100000',
        'position': 'fixed'
    });
    
    // Remover event listeners anteriores para evitar duplicação
    $('#confirmCancel').off('click');
    $('#confirmOk').off('click');
    
    // Event listeners para os botões
    $('#confirmCancel').on('click', function() {
        $('#confirmModal').hide();
    });
    
    $('#confirmOk').on('click', function() {
        $('#confirmModal').hide();
        if (onConfirm) {
            onConfirm();
        }
    });
}

// Notificações
function showNotification(message, type) {
    const notification = $(`
        <div class="notification ${type}">
            <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
            <span>${message}</span>
        </div>
    `);
    
    $('body').append(notification);
    
    setTimeout(() => {
        notification.fadeOut(() => {
            notification.remove();
        });
    }, 3000);
}

// Adicionar estilos para notificações
$('<style>')
    .prop('type', 'text/css')
    .html(`
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px 20px;
            border-radius: 8px;
            color: white;
            font-weight: 600;
            z-index: 10000;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideIn 0.3s ease;
        }
        
        .notification.success {
            background: #27ae60;
        }
        
        .notification.error {
            background: #e74c3c;
        }
        
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        .user-card, .record-item, .warrant-item, .warrant-card, .port-card, .report-card, .vehicle-card, .announcement-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .user-header, .warrant-header, .port-header, .report-header, .vehicle-header, .announcement-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .passport {
            background: #667eea;
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
        }
        
        .delete-btn, .edit-btn, .solve-btn, .release-btn {
            background: none;
            border: none;
            padding: 8px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .delete-btn {
            color: #e74c3c;
        }
        
        .edit-btn {
            color: #3498db;
        }
        
        .solve-btn {
            color: #27ae60;
        }
        
        .release-btn {
            color: #f39c12;
        }
        
        .delete-btn:hover, .edit-btn:hover, .solve-btn:hover, .release-btn:hover {
            background: rgba(0, 0, 0, 0.1);
        }
        
        .no-data, .no-results {
            text-align: center;
            color: #7f8c8d;
            padding: 40px;
            font-style: italic;
        }
        
        .announcement-footer {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            font-size: 12px;
            color: #7f8c8d;
        }
    `)
    .appendTo('head');

// Penal Code Functions
function showPenalCodeModal() {
    const modalContent = `
        <div class="penal-code-modal">
            <div class="penal-code-header">
                <h3>Código Penal - Multas</h3>
                <span>Selecione múltiplas infrações para aplicar multas</span>
            </div>
            
            <div class="penal-code-search">
                <input type="text" id="penalCodeSearch" placeholder="Buscar por nome ou artigo...">
                <select id="penalCodeCategory">
                    <option value="">Todas as categorias</option>
                    <option value="multa">Multa</option>
                </select>
            </div>
            
            <div class="selected-items-container" id="selectedFineItemsContainer" style="display: none;">
                <h4>Itens Selecionados:</h4>
                <div class="selected-items-list" id="selectedFineItemsList"></div>
                <div class="selected-items-summary">
                    <span><strong>Total Multa:</strong> $<span id="totalFineMulta">0</span></span>
                </div>
                <button class="btn btn-primary" id="applySelectedFineItems">
                    <i class="fas fa-check"></i>
                    Aplicar Multas Selecionadas
                </button>
            </div>
            
            <div class="penal-code-list" id="penalCodeList">
                <!-- Items will be loaded here -->
            </div>
        </div>
    `;
    
    showModal('Código Penal - Multas', modalContent);
    loadPenalCodeItems();
    
    // Event listeners for search and filter
    $('#penalCodeSearch').on('input', filterPenalCodeItems);
    $('#penalCodeCategory').on('change', filterPenalCodeItems);
    
    // Event listener for apply selected items
    $('#applySelectedFineItems').on('click', applySelectedFines);
}

function showPrisonPenalCodeModal() {
    const modalContent = `
        <div class="penal-code-modal">
            <div class="penal-code-header">
                <h3>Código Penal - Multas com Prisão</h3>
                <span>Selecione múltiplas infrações com penalidade de prisão</span>
            </div>
            
            <div class="penal-code-search">
                <input type="text" id="prisonPenalCodeSearch" placeholder="Buscar por nome ou artigo...">
                <select id="prisonPenalCodeCategory">
                    <option value="">Todas as categorias</option>
                    <option value="pena">Penal</option>
                </select>
            </div>
            
            <div class="selected-items-container" id="selectedItemsContainer" style="display: none;">
                <h4>Itens Selecionados:</h4>
                <div class="selected-items-list" id="selectedItemsList"></div>
                <div class="selected-items-summary">
                    <span><strong>Total Multa:</strong> $<span id="totalMulta">0</span></span>
                    <span><strong>Total Prisão:</strong> <span id="totalPrisao">0</span> meses</span>
                </div>
                <button class="btn btn-primary" id="applySelectedItems">
                    <i class="fas fa-check"></i>
                    Aplicar Prisões Selecionadas
                </button>
            </div>
            
            <div class="penal-code-list" id="prisonPenalCodeList">
                <!-- Items will be loaded here -->
            </div>
        </div>
    `;
    
    showModal('Código Penal - Multas com Prisão', modalContent);
    loadPrisonPenalCodeItems();
    
    // Event listeners for search and filter
    $('#prisonPenalCodeSearch').on('input', filterPrisonPenalCodeItems);
    $('#prisonPenalCodeCategory').on('change', filterPrisonPenalCodeItems);
    
    // Event listener for apply selected items
    $('#applySelectedItems').on('click', applySelectedPrisonFines);
}

// Global variable to store selected fine items
let selectedFineItems = [];

function loadPenalCodeItems() {
    const list = $('#penalCodeList');
    list.empty();
    
    // Reset selected items
    selectedFineItems = [];
    updateSelectedFineItemsDisplay();
    
    // Filtrar apenas itens que são multas (sem tempo de prisão)
    const fineItems = CP.codigopenal.filter(item => item.tempoPrisao === 0);
    
    fineItems.forEach(item => {
        const itemHtml = `
            <div class="penal-code-item" data-id="${item.id}" data-multa="${item.multa}" data-artigo="${item.artigo}" data-nome="${item.nome}" data-descricao="${item.descricao}">
                <div class="artigo">Artigo ${item.artigo}</div>
                <h4>${item.nome}</h4>
                <div class="descricao">${item.descricao}</div>
                <div class="valores">
                    <span class="multa">Multa: $${item.multa.toLocaleString()}</span>
                </div>
                <div class="selection-indicator">
                    <i class="fas fa-check"></i>
                </div>
            </div>
        `;
        list.append(itemHtml);
    });
    
    // Add click event to items for multiple selection
    $('.penal-code-item').on('click', function() {
        const itemId = $(this).data('id');
        const isSelected = $(this).hasClass('selected');
        
        if (isSelected) {
            // Remove from selection
            $(this).removeClass('selected');
            selectedFineItems = selectedFineItems.filter(item => item.id !== itemId);
        } else {
            // Add to selection
            $(this).addClass('selected');
            const item = {
                id: itemId,
                multa: $(this).data('multa'),
                artigo: $(this).data('artigo'),
                nome: $(this).data('nome'),
                descricao: $(this).data('descricao')
            };
            selectedFineItems.push(item);
        }
        
        updateSelectedFineItemsDisplay();
    });
}

function updateSelectedFineItemsDisplay() {
    const container = $('#selectedFineItemsContainer');
    const list = $('#selectedFineItemsList');
    const totalMulta = $('#totalFineMulta');
    
    if (selectedFineItems.length === 0) {
        container.hide();
        return;
    }
    
    container.show();
    list.empty();
    
    let totalMultaValue = 0;
    
    selectedFineItems.forEach((item, index) => {
        totalMultaValue += item.multa;
        
        const itemHtml = `
            <div class="selected-item">
                <span class="item-info">
                    <strong>${item.artigo}</strong> - ${item.nome}
                    <br><small>Multa: $${item.multa.toLocaleString()}</small>
                </span>
                <button class="remove-item-btn" onclick="removeSelectedFineItem(${index})">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        `;
        list.append(itemHtml);
    });
    
    totalMulta.text(totalMultaValue.toLocaleString());
}

function removeSelectedFineItem(index) {
    selectedFineItems.splice(index, 1);
    
    // Update visual selection
    $('.penal-code-item').each(function() {
        const itemId = $(this).data('id');
        const isInSelection = selectedFineItems.some(item => item.id === itemId);
        
        if (isInSelection) {
            $(this).addClass('selected');
        } else {
            $(this).removeClass('selected');
        }
    });
    
    updateSelectedFineItemsDisplay();
}

function applySelectedFines() {
    if (selectedFineItems.length === 0) {
        showNotification('Selecione pelo menos uma infração!', 'error');
        return;
    }
    
    // Calculate total
    const totalMulta = selectedFineItems.reduce((sum, item) => sum + item.multa, 0);
    
    // Create combined description
    const combinedDescription = selectedFineItems.map(item => 
        `${item.artigo}: ${item.nome}`
    ).join('; ');
    
    // Fill the fine form with combined data
    $('#fineAmount').val(totalMulta);
    $('#fineArticle').val('Múltiplos Artigos');
    $('#fineInfraction').val('Múltiplas Infrações');
    $('#fineDescription').val(combinedDescription);
    
    // Close modal
    closeModal();
    
    showNotification(`${selectedFineItems.length} infrações selecionadas! Preencha o passaporte e aplique as multas.`, 'success');
}

// Global variable to store selected items
let selectedPrisonItems = [];

function loadPrisonPenalCodeItems() {
    const list = $('#prisonPenalCodeList');
    list.empty();
    
    // Reset selected items
    selectedPrisonItems = [];
    updateSelectedItemsDisplay();
    
    // Filtrar apenas itens com tempo de prisão > 0
    const prisonItems = CP.codigopenal.filter(item => item.tempoPrisao > 0);
    
    prisonItems.forEach(item => {
        const itemHtml = `
            <div class="penal-code-item" data-id="${item.id}" data-multa="${item.multa}" data-artigo="${item.artigo}" data-nome="${item.nome}" data-descricao="${item.descricao}" data-tempo-prisao="${item.tempoPrisao}">
                <div class="artigo">Artigo ${item.artigo}</div>
                <h4>${item.nome}</h4>
                <div class="descricao">${item.descricao}</div>
                <div class="valores">
                    <span class="multa">Multa: $${item.multa.toLocaleString()}</span>
                    <span class="prisao">Prisão: ${item.tempoPrisao} meses</span>
                </div>
                <div class="selection-indicator">
                    <i class="fas fa-check"></i>
                </div>
            </div>
        `;
        list.append(itemHtml);
    });
    
    // Add click event to items
    $('.penal-code-item').on('click', function() {
        const itemId = $(this).data('id');
        const isSelected = $(this).hasClass('selected');
        
        if (isSelected) {
            // Remove from selection
            $(this).removeClass('selected');
            selectedPrisonItems = selectedPrisonItems.filter(item => item.id !== itemId);
        } else {
            // Add to selection
            $(this).addClass('selected');
            const item = {
                id: itemId,
                multa: $(this).data('multa'),
                artigo: $(this).data('artigo'),
                nome: $(this).data('nome'),
                descricao: $(this).data('descricao'),
                tempoPrisao: $(this).data('tempo-prisao')
            };
            selectedPrisonItems.push(item);
        }
        
        updateSelectedItemsDisplay();
    });
}

function updateSelectedItemsDisplay() {
    const container = $('#selectedItemsContainer');
    const list = $('#selectedItemsList');
    const totalMulta = $('#totalMulta');
    const totalPrisao = $('#totalPrisao');
    
    if (selectedPrisonItems.length === 0) {
        container.hide();
        return;
    }
    
    container.show();
    list.empty();
    
    let totalMultaValue = 0;
    let totalPrisaoValue = 0;
    
    selectedPrisonItems.forEach((item, index) => {
        totalMultaValue += item.multa;
        totalPrisaoValue += item.tempoPrisao;
        
        const itemHtml = `
            <div class="selected-item">
                <span class="item-info">
                    <strong>${item.artigo}</strong> - ${item.nome}
                    <br><small>Multa: $${item.multa.toLocaleString()} | Prisão: ${item.tempoPrisao} meses</small>
                </span>
                <button class="remove-item-btn" onclick="removeSelectedItem(${index})">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        `;
        list.append(itemHtml);
    });
    
    totalMulta.text(totalMultaValue.toLocaleString());
    totalPrisao.text(totalPrisaoValue);
}

function removeSelectedItem(index) {
    selectedPrisonItems.splice(index, 1);
    
    // Update visual selection
    $('.penal-code-item').each(function() {
        const itemId = $(this).data('id');
        const isInSelection = selectedPrisonItems.some(item => item.id === itemId);
        
        if (isInSelection) {
            $(this).addClass('selected');
        } else {
            $(this).removeClass('selected');
        }
    });
    
    updateSelectedItemsDisplay();
}

function applySelectedPrisonFines() {
    if (selectedPrisonItems.length === 0) {
        showNotification('Selecione pelo menos uma infração!', 'error');
        return;
    }
    
    // Calculate totals
    const totalMulta = selectedPrisonItems.reduce((sum, item) => sum + item.multa, 0);
    const totalPrisao = selectedPrisonItems.reduce((sum, item) => sum + item.tempoPrisao, 0);
    
    // Create combined description
    const combinedDescription = selectedPrisonItems.map(item => 
        `${item.artigo}: ${item.nome}`
    ).join('; ');
    
    // Fill the prison fine form with combined data
    $('#prisonFineAmount').val(totalMulta);
    $('#prisonFineArticle').val('Múltiplos Artigos');
    $('#prisonFineInfraction').val('Múltiplas Infrações');
    $('#prisonFineDescription').val(combinedDescription);
    $('#prisonFinePrisonTime').val(totalPrisao);
    
    // Close modal
    closeModal();
    
    showNotification(`${selectedPrisonItems.length} infrações selecionadas! Preencha o passaporte e aplique as multas.`, 'success');
}

function filterPenalCodeItems() {
    const searchTerm = $('#penalCodeSearch').val().toLowerCase();
    const category = $('#penalCodeCategory').val();
    
    $('.penal-code-item').each(function() {
        const item = $(this);
        const nome = item.data('nome').toLowerCase();
        const artigo = item.data('artigo').toLowerCase();
        const descricao = item.find('.descricao').text().toLowerCase();
        const cpItem = CP.codigopenal.find(cp => cp.id == item.data('id'));
        const itemCategory = cpItem ? cpItem.categoria : '';
        
        const matchesSearch = nome.includes(searchTerm) || 
                            artigo.includes(searchTerm) || 
                            descricao.includes(searchTerm);
        const matchesCategory = !category || itemCategory === category;
        
        // Para multas, só mostrar itens sem tempo de prisão
        const isFineOnly = cpItem ? cpItem.tempoPrisao === 0 : true;
        
        if (matchesSearch && matchesCategory && isFineOnly) {
            item.show();
        } else {
            item.hide();
        }
    });
}

function filterPrisonPenalCodeItems() {
    const searchTerm = $('#prisonPenalCodeSearch').val().toLowerCase();
    const category = $('#prisonPenalCodeCategory').val();
    
    $('.penal-code-item').each(function() {
        const item = $(this);
        const nome = item.data('nome').toLowerCase();
        const artigo = item.data('artigo').toLowerCase();
        const descricao = item.find('.descricao').text().toLowerCase();
        const itemCategory = CP.codigopenal.find(cp => cp.id == item.data('id')).categoria;
        
        const matchesSearch = nome.includes(searchTerm) || 
                            artigo.includes(searchTerm) || 
                            descricao.includes(searchTerm);
        const matchesCategory = !category || itemCategory === category;
        
        if (matchesSearch && matchesCategory) {
            item.show();
        } else {
            item.hide();
        }
    });
}

// Fines Lists Functions
function setupFinesListListeners() {
    $('#refreshFinesBtn').on('click', loadFinesList);
    $('#refreshPrisonFinesBtn').on('click', loadPrisonFinesList);
}

function loadFinesList() {
    $.post('https://mdt/getFines', JSON.stringify({ type: 'monetary' }), function(data) {
        if (data.success) {
            displayFinesList(data.fines, 'finesList');
        } else {
            showNotification('Erro ao carregar multas.', 'error');
        }
    });
}

function loadPrisonFinesList() {
    $.post('https://mdt/getFines', JSON.stringify({ type: 'prison' }), function(data) {
        if (data.success) {
            displayPrisonFinesList(data.fines, 'prisonFinesList');
        } else {
            showNotification('Erro ao carregar multas com prisão.', 'error');
        }
    });
}

function displayFinesList(fines, containerId) {
    const container = $(`#${containerId}`);
    
    if (!fines || fines.length === 0) {
        container.html(`
            <div class="no-fines">
                <p><i class="fas fa-info-circle"></i> Nenhuma multa monetária encontrada.</p>
            </div>
        `);
        return;
    }
    
    let html = '';
    fines.forEach(fine => {
        const message = fine.Message || 'Nenhuma observação adicional.';
        html += `
            <div class="fine-item">
                <div class="fine-header">
                    <div class="fine-name">${fine.Name}</div>
                    <div class="fine-date">${fine.Date} às ${fine.Hour}</div>
                </div>
                <div class="fine-details">
                    <span class="fine-article">ID: ${fine.Passport}</span>
                    <span class="fine-value">$${parseInt(fine.Value).toLocaleString()}</span>
                </div>
                <div class="fine-message">${message}</div>
            </div>
        `;
    });
    
    container.html(html);
}

function displayPrisonFinesList(fines, containerId) {
    const container = $(`#${containerId}`);
    
    if (!fines || fines.length === 0) {
        container.html(`
            <div class="no-fines">
                <p><i class="fas fa-info-circle"></i> Nenhuma multa com penalidade de prisão encontrada.</p>
            </div>
        `);
        return;
    }
    
    let html = '';
    fines.forEach(fine => {
        const message = fine.Message || 'Nenhuma observação adicional.';
        // Extrair tempo de prisão da mensagem se disponível
        const prisonMatch = message.match(/Prisão:\s*(\d+)\s*meses?/i);
        const prisonTime = prisonMatch ? prisonMatch[1] : 'N/A';
        
        html += `
            <div class="prison-fine-item">
                <div class="prison-fine-header">
                    <div class="prison-fine-name">${fine.Name}</div>
                    <div class="prison-fine-date">${fine.Date} às ${fine.Hour}</div>
                </div>
                <div class="prison-fine-details">
                    <span class="prison-fine-article">ID: ${fine.Passport}</span>
                    <span class="prison-fine-value">$${parseInt(fine.Value).toLocaleString()}</span>
                    <span class="prison-fine-prison-time">${prisonTime} meses</span>
                </div>
                <div class="prison-fine-message">${message}</div>
            </div>
        `;
    });
    
    container.html(html);
}

// Carregar listas quando as seções são acessadas
function handleNavigation() {
    const section = $(this).data('section');
    
    $('.nav-item').removeClass('active');
    $(this).addClass('active');
    
    $('.content-section').removeClass('active');
    $(`#${section}Section`).addClass('active');
    
    currentSection = section;
    updatePageTitle();
    
    // Carregar dados específicos da seção
    switch (section) {
        case 'dashboard':
            loadDashboardData();
            break;
        case 'warrants':
            loadWarrants();
            break;
        case 'ports':
            loadPorts();
            break;
        case 'reports':
            loadReports();
            break;
        case 'vehicles':
            loadVehicles();
            break;
        case 'announcements':
            loadAnnouncements();
            break;
        case 'fine':
            loadFinesList();
            break;
        case 'prison':
            loadPrisonFinesList();
            break;
    }
}

// Modal de Registros do Cidadão
function showCitizenRecords(passport, citizenName) {
    console.log('[MDT DEBUG] showCitizenRecords chamado com passport:', passport, 'e nome:', citizenName);
    
    // Atualizar informações do cidadão no modal
    $('#citizenName').text(citizenName);
    $('#citizenPassport').text(`Passaporte: ${passport}`);
    
    // Carregar dados do cidadão
    loadCitizenRecords(passport);
    
    // Mostrar modal
    $('#citizenRecordsModal').show();
    console.log('[MDT DEBUG] Modal de registros do cidadão aberto');
}

function closeCitizenRecordsModal() {
    $('#citizenRecordsModal').hide();
}

function loadCitizenRecords(passport) {
    console.log('[MDT DEBUG] loadCitizenRecords chamado com passport:', passport);
    
    // Carregar registros de prisão
    $.post('https://mdt/getCitizenPrisonRecords', JSON.stringify({ passport: passport }), function(response) {
        if (response.success) {
            displayCitizenPrisonRecords(response.records);
        } else {
            displayCitizenPrisonRecords([]);
        }
    });
    
    // Carregar multas em débito
    console.log('[MDT DEBUG] Chamando loadCitizenFines...');
    loadCitizenFines(passport);
    
    // Carregar mandados ativos
    $.post('https://mdt/getCitizenWarrants', JSON.stringify({ passport: passport }), function(response) {
        if (response.success) {
            displayCitizenWarrants(response.warrants);
        } else {
            displayCitizenWarrants([]);
        }
    });
}

function loadCitizenFines(passport) {
    console.log('[MDT DEBUG] loadCitizenFines chamado com passport:', passport);
    $.post('https://mdt/getCitizenFines', JSON.stringify({ passport: passport }), function(response) {
        console.log('[MDT DEBUG] Resposta do servidor:', response);
        if (response.success) {
            console.log('[MDT DEBUG] Multas encontradas:', response.fines);
            displayCitizenFines(response.fines);
        } else {
            console.log('[MDT DEBUG] Nenhuma multa encontrada');
            displayCitizenFines([]);
        }
    }).fail(function(xhr, status, error) {
        console.error('[MDT DEBUG] Erro na requisição getCitizenFines:', error);
        console.error('[MDT DEBUG] Status:', status);
        console.error('[MDT DEBUG] XHR:', xhr);
        displayCitizenFines([]);
    });
}



function displayCitizenPrisonRecords(records) {
    const container = $('#prisonRecordsList');
    
    if (!records || records.length === 0) {
        container.html(`
            <div class="no-records">
                <i class="fas fa-shield-alt"></i>
                <p>Nenhum registro de prisão encontrado.</p>
            </div>
        `);
        return;
    }
    
    let html = '';
    records.forEach(record => {
        html += `
            <div class="record-item">
                <h5>Registro de Prisão</h5>
                <p><strong>Data:</strong> ${record.date}</p>
                <p><strong>Serviços:</strong> ${record.services}</p>
                <p><strong>Multas:</strong> $${record.fines}</p>
                <p><strong>Observações:</strong> ${record.text || 'N/A'}</p>
            </div>
        `;
    });
    
    container.html(html);
}

function displayCitizenFines(fines) {
    console.log('[MDT DEBUG] displayCitizenFines chamado com:', fines);
    const container = $('#citizenFinesList');
    console.log('[MDT DEBUG] Container encontrado:', container.length > 0);
    
    if (!fines || fines.length === 0) {
        console.log('[MDT DEBUG] Nenhuma multa para exibir');
        container.html(`
            <div class="no-records">
                <i class="fas fa-ticket-alt"></i>
                <p>Nenhuma multa em débito encontrada.</p>
            </div>
        `);
        return;
    }
    
    let html = '';
    let totalValue = 0;
    
    fines.forEach((fine, index) => {
        const message = fine.Message || 'Nenhuma observação adicional.';
        const value = parseInt(fine.Value) || 0;
        totalValue += value;
        
        // Formatar data e hora
        const date = fine.Date || 'Data não informada';
        const hour = fine.Hour || 'Hora não informada';
        
        html += `
            <div class="fine-item">
                <div class="fine-header">
                    <h5>Multa #${fine.id || (index + 1)}</h5>
                    <span class="fine-value">$${value.toLocaleString()}</span>
                </div>
                <div class="fine-details">
                    <p><strong>Data:</strong> ${date} às ${hour}</p>
                    <p><strong>Registrado por:</strong> ${fine.Name || 'N/A'}</p>
                    <p><strong>Observações:</strong> ${message}</p>
                </div>
            </div>
        `;
    });
    
    // Adicionar total no final
    html += `
        <div class="fines-total">
            <h4>Total em Débito: <span class="total-value">$${totalValue.toLocaleString()}</span></h4>
        </div>
    `;
    
    console.log('[MDT DEBUG] HTML gerado:', html);
    container.html(html);
    console.log('[MDT DEBUG] HTML inserido no container');
}

function displayCitizenWarrants(warrants) {
    const container = $('#citizenWarrantsList');
    
    if (!warrants || warrants.length === 0) {
        container.html(`
            <div class="no-records">
                <i class="fas fa-search-location"></i>
                <p>Nenhum mandado ativo encontrado.</p>
            </div>
        `);
        return;
    }
    
    let html = '';
    warrants.forEach(warrant => {
        html += `
            <div class="warrant-item">
                <h5>Mandado Ativo</h5>
                <p><strong>Motivo:</strong> ${warrant.reason}</p>
                <p><strong>Data:</strong> ${warrant.timeStamp}</p>
                <p><strong>Registrado por:</strong> ${warrant.nidentity}</p>
            </div>
        `;
    });
    
    container.html(html);
}

// Event listeners para o modal de registros
$(document).ready(function() {
    // Fechar modal de registros - usando event delegation para garantir que funcione
    $(document).on('click', '#citizenRecordsClose', function(e) {
        e.preventDefault();
        e.stopPropagation();
        closeCitizenRecordsModal();
    });
    
    // Fechar modal clicando fora dele
    $(document).on('click', '#citizenRecordsModal', function(e) {
        if (e.target === this) {
            closeCitizenRecordsModal();
        }
    });
    
    // Trocar abas no modal
    $(document).on('click', '.tab-btn', function() {
        const tab = $(this).data('tab');
        
        // Atualizar botões
        $('.tab-btn').removeClass('active');
        $(this).addClass('active');
        
        // Atualizar conteúdo
        $('.tab-pane').removeClass('active');
        $(`#${tab}Tab`).addClass('active');
    });
}); 