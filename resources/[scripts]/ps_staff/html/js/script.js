let users = {}
let groups = {}
let vehicles = {}
let items = {}
let vehicle = null
let perms = {}
let item = null
let itemplayer = null
let selectedPlayer = null
let currentSection = "dashboard"
let staffInterval = null

// Sistema de atualização automática em tempo real
let autoUpdateInterval = null
let autoUpdateEnabled = true
const AUTO_UPDATE_INTERVAL = 10000 // 10 segundos

// Função para iniciar atualização automática
function startAutoUpdate() {
    if (autoUpdateInterval) {
        clearInterval(autoUpdateInterval)
    }
    
    if (autoUpdateEnabled) {
        autoUpdateInterval = setInterval(() => {
            updateAllData()
        }, AUTO_UPDATE_INTERVAL)
        
        console.log("Atualização automática iniciada - intervalo: " + AUTO_UPDATE_INTERVAL + "ms")
    }
}

// Função para parar atualização automática
function stopAutoUpdate() {
    if (autoUpdateInterval) {
        clearInterval(autoUpdateInterval)
        autoUpdateInterval = null
        console.log("Atualização automática parada")
    }
}

// Função para atualizar todos os dados
function updateAllData() {
    if (currentSection === "dashboard") {
        updateAllOnlineGroups()
        updateAllOrgCards()
    } else if (currentSection === "players") {
        updatePlayersList()
        if (selectedPlayer) {
            updatePlayerData(selectedPlayer)
        }
    }
}

// Função para atualizar lista de players
function updatePlayersList() {
    $.post('https://ps_staff/getAllUsers', {}, function(data) {
        if (data && Array.isArray(data)) {
            users = data
            loadusers()
            
            // Manter seleção atual se o player ainda existir
            if (selectedPlayer) {
                const playerExists = users.some(user => user.user_id === selectedPlayer)
                if (!playerExists) {
                    selectedPlayer = null
                    $("#playerData").html('<p class="no-selection">Selecione um player para ver os detalhes</p>')
                }
            }
        }
    }, 'json')
}

// Função para atualizar dados de um player específico
function updatePlayerData(userId) {
    if (!userId) return
    
    $.post("https://ps_staff/getuser", JSON.stringify({ id: userId }), (data) => {
        if (data) {
            // Atualizar dados do player na interface
            const playerData = $("#playerData")
            if (playerData.find(`[data-userid="${userId}"]`).length > 0) {
                // Recarregar dados do player selecionado
                loaduserdata(userId)
            }
        }
    })
}

// Função para atualizar grupos
function updateGroups() {
    $.post('https://ps_staff/getAllGroups', {}, function(data) {
        if (data && Array.isArray(data)) {
            groups = data
            loadgroups()
        }
    }, 'json')
}

// Função para lidar com mudanças em grupos
function handleGroupChange(data) {
    console.log("Mudança detectada no grupo:", data)
    
    // Atualizar dados relevantes baseado no tipo de mudança
    if (data.type === "add" || data.type === "remove") {
        // Atualizar lista de players se estiver na seção de players
        if (currentSection === "players") {
            updatePlayersList()
        }
        
        // Atualizar cards de organizações se estiver no dashboard
        if (currentSection === "dashboard") {
            updateAllOrgCards()
        }
        
        // Se um player específico está selecionado e foi afetado, atualizar seus dados
        if (selectedPlayer && data.user_id === selectedPlayer) {
            console.log("Atualizando dados do player selecionado devido a mudança de grupo")
            
            // Fazer uma nova requisição para obter dados atualizados
            $.post("https://ps_staff/getuser", JSON.stringify({ id: selectedPlayer }), (userData) => {
                if (userData) {
                    console.log("Dados atualizados recebidos:", userData)
                    
                    // Atualizar apenas a seção de grupos
                    const groupsContainer = $('.roles-list')
                    if (groupsContainer.length > 0) {
                        let groupsHtml = ''
                        
                        if (userData.groups && userData.groups.length > 0) {
                            userData.groups.forEach(group => {
                                // Definir ícone baseado no tipo de cargo
                                let roleIcon = "👤"
                                let roleColor = "#35bc98"
                                
                                if (group.name.toLowerCase().includes("police") || group.name.toLowerCase().includes("policial") || group.name.toLowerCase().includes("prf") || group.name.toLowerCase().includes("pcivil") || group.name.toLowerCase().includes("core")) {
                                    roleIcon = "👮"
                                    roleColor = "#3498db"
                                } else if (group.name.toLowerCase().includes("paramedic") || group.name.toLowerCase().includes("médico") || group.name.toLowerCase().includes("medico")) {
                                    roleIcon = "🚑"
                                    roleColor = "#e74c3c"
                                } else if (group.name.toLowerCase().includes("mechanic") || group.name.toLowerCase().includes("mecânico") || group.name.toLowerCase().includes("mecanico")) {
                                    roleIcon = "🔧"
                                    roleColor = "#f39c12"
                                } else if (group.name.toLowerCase().includes("admin") || group.name.toLowerCase().includes("staff") || group.name.toLowerCase().includes("manager")) {
                                    roleIcon = "⭐"
                                    roleColor = "#9b59b6"
                                }
                                
                                groupsHtml += `
                                    <div class="role-item">
                                        <div class="role-info">
                                            <div class="role-badge">
                                                <span class="role-icon" style="background: linear-gradient(135deg, ${roleColor} 0%, ${roleColor}dd 100%);">${roleIcon}</span>
                                                <div class="role-details">
                                                    <span class="role-name">${group.name}</span>
                                                    <span class="role-level">${group.levelName || 'Nível ' + (group.level || 1)}</span>
                                                </div>
                                            </div>
                                        </div>
                                        ${group.group !== "Admin" ? `
                                        <div class="role-actions">
                                            <button class="btn-small btn-remove" onclick="removeGroup('${selectedPlayer}', '${group.group}')">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                        ` : ""}
                                    </div>
                                `
                            })
                        } else {
                            groupsHtml = '<div class="role-empty">Nenhum cargo atribuído</div>'
                        }
                        
                        // Adicionar botão de adicionar cargo se tiver permissão
                        if (perms && perms.groups) {
                            groupsHtml += `
                                <button class="btn-small btn-add" onclick="showAddGroupModal('${selectedPlayer}')">
                                    <i class="fas fa-plus"></i> Adicionar Cargo
                                </button>
                            `
                        }
                        
                        groupsContainer.html(groupsHtml)
                        console.log("Seção de grupos atualizada em tempo real")
                    }
                }
            })
        }
    }
}

// Função para lidar com mudanças em players
function handlePlayerChange(data) {
    console.log("Mudança detectada no player:", data)
    
    // Atualizar lista de players
    if (currentSection === "players") {
        updatePlayersList()
    }
    
    // Se o player afetado está selecionado, atualizar seus dados
    if (selectedPlayer && data.user_id === selectedPlayer) {
        updatePlayerData(selectedPlayer)
    }
}



// Declare the $ variable
const $ = window.$

$(document).ready(() => {
  // Inicializar com a seção Dashboard ativa
  showSection("dashboard")

  // Evento do botão de atualizar dashboard
  $("#refreshDashboardBtn").on("click", function() {
    updateOnlinePlayers()
    updateOnlineStaff()
    updateAllOrgCards()
    this.blur()
  })

  // Botão de atualizar apenas os cards de organizações
  $('#refreshOrgCardsBtn').on('click', function() {
    updateAllOrgCards();
    this.blur();
  });

  // Botão de controle de atualização automática
  $('#toggleAutoUpdate').on('click', function() {
    autoUpdateEnabled = !autoUpdateEnabled;
    
    if (autoUpdateEnabled) {
      startAutoUpdate();
      $(this).removeClass('inactive').addClass('active');
      $('#autoUpdateStatus').text('Ativo');
    } else {
      stopAutoUpdate();
      $(this).removeClass('active').addClass('inactive');
      $('#autoUpdateStatus').text('Inativo');
    }
    
    this.blur();
  });

  window.addEventListener("message", (event) => {
    const data = event.data
    switch (data.action) {
      case "loadstaff":
        loadstaff(data.staff)
        break
      case "loadusers":
        users = data.users
        loadusers()
        // Selecionar automaticamente o primeiro user_id válido (> 0)
        const validUserIds = Object.keys(users).filter(id => Number(id) > 0)
        if (validUserIds.length > 0 && currentSection === "players") {
          const firstUserId = validUserIds[0]
          const firstUserIdNum = Number.parseInt(firstUserId)

          if (firstUserIdNum && firstUserIdNum > 0) {
            selectPlayer(firstUserIdNum)
          } else {
            console.log("ID inválido, não selecionando player automaticamente")
          }
        } else {
          console.log("Nenhum user_id válido encontrado na lista de usuários.")
        }
        break
      case "loadgroups":
        groups = data.groups
        loadgroups()
        break
      case "loadvehicles":
        vehicles = data.vehicles
        vehicle = null
        loadvehicles()
        break
      case "loaditems":
        items = data.items
        item = null
        itemplayer = null
        loaditems()
        break
      case "loadmessages":
        loadchatmessages(data.messages)
        break
      case "showmenu":
        $("body").show()
        $("#mainPage").show().css({
          opacity: "1",
          transform: "translate(-50%, -50%)",
          position: "absolute",
          top: "50%",
          left: "50%"
        })
        updateAllOrgCards(); // Atualiza todos os cards ao abrir o painel
        startAutoUpdate(); // Inicia atualização automática
        break
      case "hidemenu":
        $("body").hide()
        stopAutoUpdate(); // Para atualização automática
        break
      case "openchatstaff":
        openChatStaff()
        break
      case "closechatstaff":
        closeChatStaff()
        break
      case "loadchatstaffmessages":
        loadChatStaffMessages(data.messages)
        break
      case "newchatstaffmessage":
        receiveChatStaffMessage(data.message)
        break
      case "groupChanged":
        handleGroupChange(data.data)
        break
      case "playerChanged":
        handlePlayerChange(data.data)
        break

    }
  })

  // Fechar com ESC
  document.onkeyup = (data) => {
    if (data.which == 27) {
      if ($(".modal-overlay").is(":visible")) {
        $(".modal-overlay").hide()
      } else {
        $.post("https://ps_staff/close")
      }
    }
  }

  // Menu navigation
  $(".menu-item").click(function () {
    const section = $(this).data("section")
    showSection(section)
    if(section === "dashboard") {
      updateAllOnlineGroups()
      // Inicia atualização automática
      if (staffInterval) clearInterval(staffInterval);
      staffInterval = setInterval(() => {
        updateAllOnlineGroups();
      }, 5000); // Atualiza a cada 5 segundos (otimizado)
    } else {
      // Para o intervalo se sair do dashboard
      if (staffInterval) clearInterval(staffInterval);
    }
  })

  // Search functionality
  $(document).on("keyup", "#txtBusca, #txtBuscaBan", function (e) {
    const texto = $(this).val().toLowerCase()
    const container = $(this).closest(".list-panel").find(".players-list")

    container.find(".player-item").each(function () {
      const playerText = $(this).text().toLowerCase()
      if (playerText.indexOf(texto) < 0) {
        $(this).addClass("filter")
      } else {
        $(this).removeClass("filter")
      }
    })
  })



  // Inventory item selection
  $(document).on("click", ".inventory-item", function () {
    $(".inventory-item").removeClass("selected")
    $(this).addClass("selected")
  })

  // Inventory view toggle
  $(document).on("click", "#gridViewBtn", function () {
    $("#gridViewBtn").addClass("active")
    $("#listViewBtn").removeClass("active")
    $("#playerInventoryGrid").removeClass("list-view").addClass("grid-view")
  })

  $(document).on("click", "#listViewBtn", function () {
    $("#listViewBtn").addClass("active")
    $("#gridViewBtn").removeClass("active")
    $("#playerInventoryGrid").removeClass("grid-view").addClass("list-view")
  })

  // Player selection
  $(document).on("click", ".player-item", function (e) {
    const userId = $(this).data("user_id")
    console.log("Player selecionado:", userId)
    selectPlayer(userId)
  })

  // Modal handlers
  $(document).on("click", "#cancelCargo, #cancelBan, #closeChatStaff", () => {
    $(".modal-overlay").hide()
  })

  // Vehicle and item search
  $(document).on("keyup", "#txtBuscaVehicle", function (e) {
    const texto = $(this).val().toLowerCase()
    $("#vehiclesGrid .vehicle-card").each(function () {
      if ($(this).text().toLowerCase().indexOf(texto) < 0) {
        $(this).addClass("filter")
      } else {
        $(this).removeClass("filter")
      }
    })
  })

  $(document).on("keyup", "#itemOther", function (e) {
    const texto = $(this).val().toLowerCase()
    const container = $(this).closest(".spawn-form").find(".items-grid")

    container.find(".item-card").each(function () {
      if ($(this).text().toLowerCase().indexOf(texto) < 0) {
        $(this).addClass("filter")
      } else {
        $(this).removeClass("filter")
      }
    })
  })

  // Item and vehicle selection
  $(document).on("click", ".item-card", function () {
    const container = $(this).closest(".items-grid")
    container.find(".item-card").removeClass("selected")
    $(this).addClass("selected")

    const itemData = $(this).data("item")
    if (container.closest(".spawn-form").find("#itemOther").length) {
      itemplayer = itemData
    } else {
      item = itemData
    }
  })

  $(document).on("click", ".vehicle-card", function () {
    $(".vehicle-card").removeClass("selected")
    $(this).addClass("selected")
    vehicle = $(this).data("vehicle")
  })

  // Chat Staff Event Listeners
  $("#chatStaffInput").on("input", function () {
    const length = $(this).val().length
    const counter = $("#charCount")
    const sendBtn = $("#sendChatStaff")

    counter.text(length)

    // Update counter color
    counter.parent().removeClass("warning danger")
    if (length > 400) {
      counter.parent().addClass("danger")
    } else if (length > 300) {
      counter.parent().addClass("warning")
    }

    // Enable/disable send button
    sendBtn.prop("disabled", length === 0 || length > 500)
  })

  $("#chatStaffInput").keypress((e) => {
    if (e.which === 13 && !$("#sendChatStaff").prop("disabled")) {
      sendChatStaffMessage()
    }
  })

  $("#sendChatStaff").click(() => {
    sendChatStaffMessage()
  })

  $(document).off('click', '#spawnOther').on('click', '#spawnOther', function () {
    // Pega o item selecionado visualmente
    const selectedCard = $('#itemsGridOther .item-card.selected');
    // Força o valor a ser string
    const selectedItem = selectedCard.length ? String(selectedCard.attr('data-item')) : null;
    const passport = $('#passportOther').val().trim();
    let quantity = parseInt($('#quantityOther').val(), 10);
    
    if (!selectedItem) {
      $.post('https://ps_staff/notify', JSON.stringify({ type: 'vermelho', message: 'Selecione um item na lista para spawnar!' }));
      return;
    }
    
    // Se quantidade não for válida, usar 1 como padrão
    if (!quantity || quantity <= 0) quantity = 1;
    
    // Preparar dados para enviar
    const spawnData = {
      item: selectedItem,
      amount: quantity
    };
    
    // Se passport foi preenchido, adicionar ao objeto
    if (passport) {
      spawnData.id = passport;
    }
    
    $.post('https://ps_staff/spawnitem', JSON.stringify(spawnData), function(response) {
      if (response && response.success) {
        $.post('https://ps_staff/notify', JSON.stringify({ type: 'verde', message: response.message || 'Item spawnado com sucesso!' }));
      } else {
        $.post('https://ps_staff/notify', JSON.stringify({ type: 'vermelho', message: response ? response.message : 'Erro ao spawnar item!' }));
      }
    });
  });

  // Eventos para spawn de veículos
  $(document).on("click", "#spawnVehicle", function () {
    if (!vehicle) {
      $.post("https://ps_staff/notify", JSON.stringify({ type: "vermelho", message: "Selecione um veículo para spawnar!" }))
      return
    }
    $.post("https://ps_staff/spawnvehicle", JSON.stringify({ id: 0, vehicle: vehicle }), function (data) {
      if (data && data.success) {
        $.post("https://ps_staff/notify", JSON.stringify({ type: "verde", message: "Carro spawnado com sucesso!" }))
        // Fechar o painel instantaneamente
        $.post("https://ps_staff/close")
      } else {
        $.post("https://ps_staff/notify", JSON.stringify({ type: "vermelho", message: data && data.message ? data.message : "Erro ao spawnar veículo!" }))
      }
    })
  })

  $(document).on("click", "#addVehicle", function () {
    if (!vehicle) {
      $.post("https://ps_staff/notify", JSON.stringify({ type: "vermelho", message: "Selecione um veículo para adicionar!" }))
      return
    }
    const id = parseInt($("#vehiclePlayerId").val()) || 0
    if (id <= 0) {
      $.post("https://ps_staff/notify", JSON.stringify({ type: "vermelho", message: "Informe um ID válido!" }))
      return
    }
    $.post("https://ps_staff/addvehicle", JSON.stringify({ id: id, vehicle: vehicle }), function (data) {
      if (data && data.success) {
        $.post("https://ps_staff/notify", JSON.stringify({ type: "verde", message: data.message }))
      } else {
        $.post("https://ps_staff/notify", JSON.stringify({ type: "vermelho", message: data && data.message ? data.message : "Erro ao adicionar veículo!" }))
      }
    })
  })

  // Adicionar evento de clique para selecionar veículos
  $(document).on('click', '.garage-item', function() {
    $('.garage-item').removeClass('selected');
    $(this).addClass('selected');
  });

  $(document).on('click', '#removeVehicleBtn', function() {
    const selected = $('.garage-item.selected');
    if (selected.length === 0) {
      createAlert('danger', 'Erro', 'Selecione um veículo para remover!', 2500);
      return;
    }
    
    // Preencher informações do modal
    const vehicle = selected.data('vehicle');
    const plate = selected.data('plate');
    const vehicleName = selected.find('.garage-name').text();
    
    $('#vehicleName').text(vehicleName);
    $('#vehiclePlate').text(plate);
    $('#removeVehicleModal').show();
  });

  $(document).on('click', '#cancelRemoveVehicle', function() {
    $('#removeVehicleModal').hide();
    // Limpar dados do modal
    $('#vehicleName').text('');
    $('#vehiclePlate').text('');
    // Limpar seleções
    $('.garage-item').removeClass('selected');
  });

  $(document).on('click', '#confirmRemoveVehicle', function() {
    const selected = $('.garage-item.selected');
    if (selected.length === 0) return;
    const vehicle = selected.data('vehicle');
    const plate = selected.data('plate');
    // Pegar o userId da div .player-details
    const userId = $('.player-details').data('userid');
    
    // Desabilitar o botão para evitar múltiplos cliques
    $('#confirmRemoveVehicle').prop('disabled', true).text('Removendo...');
    
    $.post('https://ps_staff/removevehicle', JSON.stringify({ user_id: userId, vehicle: vehicle, plate: plate }), function(resp) {
      if (resp && resp.success) {
        // Fechar o modal primeiro
        $('#removeVehicleModal').hide();
        
        // Limpar seleções
        $('.garage-item').removeClass('selected');
        
        // Recarregar os dados do usuário para atualizar a lista
        setTimeout(() => {
          loaduserdata(userId);
        }, 100);
      } else {
        createAlert('danger', 'Erro', resp ? resp.message : 'Não foi possível remover o veículo.', 2500);
      }
    }).fail(function() {
      createAlert('danger', 'Erro', 'Erro de comunicação com o servidor.', 2500);
    }).always(function() {
      // Reabilitar o botão
      $('#confirmRemoveVehicle').prop('disabled', false).text('Confirmar');
    });
  });

  // Atualizar número de players online ao abrir o painel
  updateAllOnlineGroups()

  // Evento para expandir/collapse e carregar membros do grupo Staff
  $(document).on("click", "#orgStaff .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Admin
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Police
  $(document).on("click", "#orgPolice .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Police
      $.post(`https://${GetParentResourceName()}/getAllPoliceMembers`, JSON.stringify({}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo PRF
  $(document).on("click", "#orgPRF .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo PRF
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'PRF'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo PCivil
  $(document).on("click", "#orgPCivil .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo PCivil
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'PCivil'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Core
  $(document).on("click", "#orgCore .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Core
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Core'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Oficina01
  $(document).on("click", "#orgOficina01 .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Oficina01
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Oficina01'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Oficina02
  $(document).on("click", "#orgOficina012 .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Oficina02
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Oficina02'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Harmony
  $(document).on("click", "#orgHarmony .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Harmony
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Harmony'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Judiciary
  $(document).on("click", "#orgJudiciary .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Judiciary
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Judiciary'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Paramedic
  $(document).on("click", "#orgParamedic .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Paramedic
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Paramedic'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo BurgerShot
  $(document).on("click", "#orgBurgerShot .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo BurgerShot
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'BurgerShot'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Pearls
  $(document).on("click", "#orgPearls .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Pearls
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Pearls'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Playboy
  $(document).on("click", "#orgPlayboy .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Playboy
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Playboy'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Madrazzo
  $(document).on("click", "#orgMadrazzo .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Madrazzo
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Madrazzo'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo TheSouth
  $(document).on("click", "#orgTheSouth .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo TheSouth
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'TheSouth'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Vineyard
  $(document).on("click", "#orgVineyard .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Vineyard
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Vineyard'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Barragem
  $(document).on("click", "#orgBarragem .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Barragem
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Barragem'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Farol
  $(document).on("click", "#orgFarol .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Farol
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Farol'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Parque
  $(document).on("click", "#orgParque .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Parque
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Parque'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Sandy
  $(document).on("click", "#orgSandy .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Sandy
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Sandy'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Petroleo
  $(document).on("click", "#orgPetroleo .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Petroleo
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Petroleo'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Praia-1
  $(document).on("click", "#orgPraia1 .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Praia-1
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Praia-1'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Praia-2
  $(document).on("click", "#orgPraia2 .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Praia-2
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Praia-2'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Zancudo
  $(document).on("click", "#orgZancudo .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Zancudo
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Zancudo'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Chiliad
  $(document).on("click", "#orgChiliad .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Chiliad
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Chiliad'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });

  // Evento para expandir/collapse e carregar membros do grupo Vagos
  $(document).on("click", "#orgVagos .org-card-main", function () {
    const card = $(this).closest(".org-card");
    const details = card.find(".org-card-details");
    if (card.attr("open")) {
      card.removeAttr("open");
      details.slideUp(180);
    } else {
      // Buscar membros do grupo Vagos
      $.post(`https://${GetParentResourceName()}/getAllStaffMembers`, JSON.stringify({group: 'Vagos'}), function (data) {
        if (Array.isArray(data)) {
          card.find(".org-card-members").text(`(${data.length} membros)`);
          let html = '<ul style="list-style:none;padding:0;margin:0;">';
          data.forEach(member => {
            html += `<li style='display:flex;align-items:center;gap:10px;margin-bottom:8px;'>
              <span style='font-weight:600;color:#35bc98;'>#${member.user_id}</span>
              <span style='flex:1;color:#222;'>${member.name}</span>
              <span style='font-size:12px;color:${member.online ? '#35bc98' : '#aaa'};'>${member.online ? 'Online' : 'Offline'}</span>
            </li>`;
          });
          html += '</ul>';
          details.html(html);
        } else {
          details.html('<span style=\"color:#c00;\">Erro ao carregar membros.</span>');
        }
        card.attr("open", true);
        details.slideDown(180);
      }, 'json');
    }
  });
})

function showSection(sectionName) {
  currentSection = sectionName

  // Update menu
  $(".menu-item").removeClass("active")
  $(`.menu-item[data-section="${sectionName}"]`).addClass("active")

  // Update title
  const titles = {
    players: "Players",
    banimentos: "Punições",
    spawnitens: "Spawn Itens",
    spawnveiculos: "Spawn Veículos",
  }

  $("#titleContent .section-title").text(titles[sectionName] || sectionName)

  // Show section
  $(".section").hide()
  $(`.section.${sectionName}`).show()

  // Load data based on section
  switch (sectionName) {
    case "players":
    case "banimentos":
      loadusers()
      // Atualizar dados imediatamente ao mudar para seção de players
      if (autoUpdateEnabled) {
        updatePlayersList()
      }
      break
    case "spawnitens":
      loaditems()
      break
    case "spawnveiculos":
      loadvehicles()
      break
  }
}

function loadstaff(data) {
  $(".user-info .cargo").text(data.role)
  $(".user-info .nome").text(data.name + " #" + data.user_id)
  perms = data.perms

  // Hide menu items based on permissions
  if (!perms["players"]) $(".menu-item[data-section='players']").hide()
  if (!perms["punishments"]) $(".menu-item[data-section='banimentos']").hide()
  if (!perms["spawnitems"]) $(".menu-item[data-section='spawnitens']").hide()
  if (!perms["spawnvehicles"]) $(".menu-item[data-section='spawnveiculos']").hide()
}

function loadusers() {
  const containers = ["#principal", "#principalBan"]

  containers.forEach((container) => {
    $(container).html("")

    const sortedUsers = Object.values(users).sort((a, b) => a.user_id - b.user_id)

    sortedUsers.forEach((user) => {
      const html = `
            <div class="player-item" data-user_id="${user.user_id}">
                <div class="player-avatar">${user.name.charAt(0).toUpperCase()}</div>
                <div class="player-info-item">
                    <div class="id">#${user.user_id}</div>
                    <div class="name">${user.name}</div>
                    <div class="status ${user.online ? "online" : "offline"}">${user.online ? "Online" : "Offline"}</div>
                </div>
            </div>
        `
      $(container).append(html)
    })
  })
}

function selectPlayer(userId) {
  console.log("selectPlayer chamado com userId:", userId)
  $(".player-item").removeClass("selected")
  $(`.player-item[data-user_id="${userId}"]`).addClass("selected")
  selectedPlayer = userId

  // Limpar seleções de veículos ao trocar de jogador
  $('.garage-item').removeClass('selected');

  // Limpar inventário anterior se trocar de player
  if (currentInventoryUserId && currentInventoryUserId !== userId) {
    $('.inventory-grid').off('scroll.inventory')
    $('.inventory-grid').html('')
  }

  switch (currentSection) {
    case "players":
      console.log("Chamando loaduserdata para userId:", userId)
      loaduserdata(userId)
      break
    case "banimentos":
      console.log("Chamando loaduserwarnings para userId:", userId)
      loaduserwarnings(userId)
      break
  }
}

function loaduserdata(user_id) {
  console.log("loaduserdata iniciado com user_id:", user_id)
  if (!user_id || user_id === 0 || user_id === "0") {
    console.log("loaduserdata: ID inválido:", user_id)
    return
  }

  user_id = Number.parseInt(user_id)
  if (isNaN(user_id) || user_id <= 0) {
    console.log("loaduserdata: ID não é um número válido:", user_id)
    return
  }

  console.log("Fazendo requisição para ps_staff/getuser com id:", user_id)
  // Limpar seleções antes de carregar novos dados
  $('.garage-item').removeClass('selected');

  $.post("https://ps_staff/getuser", JSON.stringify({ id: user_id }), (data) => {
    console.log("Resposta recebida do servidor:", data)
    console.log("Tipo da resposta:", typeof data)
    if (data) {
      const playerData = $("#playerData")
      // Adicionar data-userid na div .player-details
      const html = `
                <div class="player-details" data-userid="${data.user_id}">
                    <div class="detail-section">
                        <h4>Informações Pessoais</h4>
                        <div class="detail-item">
                            <span class="detail-label">Nome:</span>
                            <span class="detail-value">${data.name} #${data.user_id}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Idade:</span>
                            <span class="detail-value">${data.age}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Telefone:</span>
                            <span class="detail-value">${data.phone}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Registro:</span>
                            <span class="detail-value">${data.registration}</span>
                        </div>
                    </div>
                    
                    <div class="detail-section">
                        <h4>Informações Financeiras</h4>
                        <div class="detail-item">
                            <span class="detail-label">Banco:</span>
                            <span class="detail-value">${formatCurrency(data.bank)}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Multas:</span>
                            <span class="detail-value">${formatCurrency(data.fines)}</span>
                        </div>
                    </div>
                    <div class="detail-section">
                        <h4>Registro de Penalidade</h4>
                        <div class="detail-item">
                            <span class="detail-label">Banido:</span>
                            <span class="detail-value">${data.banned ? "Sim" : "Não"}</span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Advertências:</span>
                            <span class="detail-value">${data.warnings.length}</span>
                        </div>
                    </div>
                    <div class="detail-section">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <h4 style="margin: 0;">Garagem</h4>
                            <button id="removeVehicleBtn" class="btn-remove" style="margin-left: 10px; font-size: 13px; padding: 4px 12px;">Remover</button>
                        </div>
                        <div class="garage-grid">
                            ${data.garage && data.garage.length > 0 ?
                              data.garage.map(
                                (car, idx) => `
                                <div class="garage-item" data-vehicle="${car.vehicle}" data-plate="${car.plate}" data-index="${idx}">
                                    <div class="garage-name">${car.name}</div>
                                    <div class="garage-plate">${car.plate}</div>
                                </div>
                            `).join("") : '<div class="garage-empty">Nenhum veículo encontrado.</div>'}
                        </div>
                    </div>
                </div>
                
                <div class="detail-section">
                    <h4>Inventário</h4>
                    <div class="inventory-controls">
                        <div class="inventory-view-toggle">
                            <button id="gridViewBtn" class="view-btn active" title="Visualização em Grid">
                                <i class="fas fa-th"></i>
                            </button>
                            <button id="listViewBtn" class="view-btn" title="Visualização em Lista">
                                <i class="fas fa-list"></i>
                            </button>
                        </div>
                    </div>
                    <div class="inventory-grid grid-view" id="playerInventoryGrid"></div>
                </div>
                
                <div class="detail-section">
                    <h4>Cargos</h4>
                    <div class="roles-list">
                        ${data.groups && data.groups.length > 0 
                          ? data.groups
                            .map(
                              (group) => {
                                // Definir ícone baseado no tipo de cargo
                                let roleIcon = "👤";
                                let roleColor = "#35bc98";
                                
                                                              if (group.name.toLowerCase().includes("police") || group.name.toLowerCase().includes("policial") || group.name.toLowerCase().includes("prf") || group.name.toLowerCase().includes("pcivil") || group.name.toLowerCase().includes("core")) {
                                roleIcon = "👮";
                                roleColor = "#3498db";
                              } else if (group.name.toLowerCase().includes("paramedic") || group.name.toLowerCase().includes("médico") || group.name.toLowerCase().includes("medico")) {
                                roleIcon = "🚑";
                                roleColor = "#e74c3c";
                              } else if (group.name.toLowerCase().includes("mechanic") || group.name.toLowerCase().includes("mecânico") || group.name.toLowerCase().includes("mecanico")) {
                                roleIcon = "🔧";
                                roleColor = "#f39c12";
                              } else if (group.name.toLowerCase().includes("taxi") || group.name.toLowerCase().includes("uber") || group.name.toLowerCase().includes("motorista")) {
                                roleIcon = "🚕";
                                roleColor = "#f1c40f";
                              } else if (group.name.toLowerCase().includes("admin") || group.name.toLowerCase().includes("staff") || group.name.toLowerCase().includes("manager")) {
                                roleIcon = "⭐";
                                roleColor = "#9b59b6";
                              } else if (group.name.toLowerCase().includes("lawyer") || group.name.toLowerCase().includes("advogado") || group.name.toLowerCase().includes("judiciary")) {
                                roleIcon = "⚖️";
                                roleColor = "#34495e";
                              } else if (group.name.toLowerCase().includes("farmer") || group.name.toLowerCase().includes("fazendeiro")) {
                                roleIcon = "🌾";
                                roleColor = "#27ae60";
                              } else if (group.name.toLowerCase().includes("trucker") || group.name.toLowerCase().includes("caminhoneiro")) {
                                roleIcon = "🚛";
                                roleColor = "#8e44ad";
                              } else if (group.name.toLowerCase().includes("fisherman") || group.name.toLowerCase().includes("pescador")) {
                                roleIcon = "🎣";
                                roleColor = "#3498db";
                              } else if (group.name.toLowerCase().includes("miner") || group.name.toLowerCase().includes("minerador")) {
                                roleIcon = "⛏️";
                                roleColor = "#7f8c8d";
                              } else if (group.name.toLowerCase().includes("lumberjack") || group.name.toLowerCase().includes("lenhador")) {
                                roleIcon = "🪓";
                                roleColor = "#8b4513";
                              } else if (group.name.toLowerCase().includes("realestate") || group.name.toLowerCase().includes("corretor")) {
                                roleIcon = "🏠";
                                roleColor = "#e67e22";
                              } else if (group.name.toLowerCase().includes("banker") || group.name.toLowerCase().includes("banqueiro")) {
                                roleIcon = "💰";
                                roleColor = "#f1c40f";
                              } else if (group.name.toLowerCase().includes("news") || group.name.toLowerCase().includes("jornalista")) {
                                roleIcon = "📰";
                                roleColor = "#e74c3c";
                              } else if (group.name.toLowerCase().includes("garbage") || group.name.toLowerCase().includes("lixeiro")) {
                                roleIcon = "🗑️";
                                roleColor = "#95a5a6";
                              } else if (group.name.toLowerCase().includes("delivery") || group.name.toLowerCase().includes("entregador")) {
                                roleIcon = "📦";
                                roleColor = "#e67e22";
                              } else if (group.name.toLowerCase().includes("pearls") || group.name.toLowerCase().includes("burgershot") || group.name.toLowerCase().includes("restaurant")) {
                                roleIcon = "🍽️";
                                roleColor = "#e67e22";
                              } else if (group.name.toLowerCase().includes("families") || group.name.toLowerCase().includes("vagos") || group.name.toLowerCase().includes("highways") || group.name.toLowerCase().includes("chiliad")) {
                                roleIcon = "🦹";
                                roleColor = "#e74c3c";
                              } else if (group.name.toLowerCase().includes("barragem") || group.name.toLowerCase().includes("farol") || group.name.toLowerCase().includes("parque") || group.name.toLowerCase().includes("sandy") || group.name.toLowerCase().includes("petroleo") || group.name.toLowerCase().includes("praia") || group.name.toLowerCase().includes("zancudo")) {
                                roleIcon = "🏘️";
                                roleColor = "#8b4513";
                              } else if (group.name.toLowerCase().includes("madrazzo") || group.name.toLowerCase().includes("playboy") || group.name.toLowerCase().includes("thesouth") || group.name.toLowerCase().includes("vineyard")) {
                                roleIcon = "🎭";
                                roleColor = "#9b59b6";
                              } else if (group.name.toLowerCase().includes("harmony") || group.name.toLowerCase().includes("ottos") || group.name.toLowerCase().includes("dk")) {
                                roleIcon = "🔧";
                                roleColor = "#f39c12";
                              } else if (group.name.toLowerCase().includes("premium")) {
                                roleIcon = "💎";
                                roleColor = "#f1c40f";
                              }
                                
                                return `
                                  <div class="role-item">
                                      <div class="role-info">
                                          <div class="role-badge">
                                              <span class="role-icon" style="background: linear-gradient(135deg, ${roleColor} 0%, ${roleColor}dd 100%);">${roleIcon}</span>
                                                                                          <div class="role-details">
                                                <span class="role-name">${group.name}</span>
                                                <span class="role-level">${group.levelName || 'Nível ' + (group.level || 1)}</span>
                                            </div>
                                          </div>
                                      </div>
                                      ${
                                        group.group !== "Admin"
                                          ? `
                                          <div class="role-actions">
                                              <button class="btn-small btn-remove" onclick="removeGroup('${user_id}', '${group.group}')">
                                                  <i class="fas fa-trash"></i>
                                              </button>
                                          </div>
                                      `
                                          : ""
                                      }
                                  </div>
                              `;
                              }
                            )
                            .join("")
                          : '<div class="role-empty">Nenhum cargo atribuído</div>'
                        }
                        ${
                          perms["groups"]
                            ? `
                            <button class="btn-small btn-add" onclick="showAddGroupModal('${user_id}')">
                                <i class="fas fa-plus"></i> Adicionar Cargo
                            </button>
                        `
                            : ""
                        }
                    </div>
                </div>
            `

      playerData.html(html)
      
      // Inicializar o inventário melhorado com imagens
      console.log("Dados completos recebidos:", data)
      console.log("Dados do inventário recebidos:", data.inventory)
      console.log("Tipo de dados do inventário:", typeof data.inventory)
      console.log("É array?", Array.isArray(data.inventory))
      
      // Verificar se há outras propriedades que podem conter o inventário
      const possibleInventoryProps = ['inventory', 'inventario', 'items', 'itens', 'bag']
      let inventoryData = null
      
      for (const prop of possibleInventoryProps) {
        if (data[prop] && Array.isArray(data[prop]) && data[prop].length > 0) {
          console.log(`Inventário encontrado na propriedade: ${prop}`)
          inventoryData = data[prop]
          break
        }
      }
      
      if (inventoryData) {
        console.log("Inventário encontrado com", inventoryData.length, "itens")
        console.log("Primeiro item:", inventoryData[0])
        // Usar a nova função de display de inventário
        displayUserInventory(inventoryData, user_id)
      } else {
        console.log("Inventário vazio ou não encontrado")
        $('#playerInventoryGrid').html('<div class="inventory-empty">Inventário vazio</div>')
      }
    } else {
      console.log("Nenhum dado retornado para o usuário:", user_id)
      const playerData = $("#playerData")
      playerData.html('<p class="no-selection">Erro ao carregar dados do player</p>')
    }
  }).fail((error) => {
    console.log("Erro na requisição para o usuário:", user_id)
    console.log("Detalhes do erro:", error)
    const playerData = $("#playerData")
    playerData.html('<p class="no-selection">Erro na comunicação com o servidor</p>')
  })
}

function loaduserwarnings(user_id) {
  $.post("https://ps_staff/getuser", JSON.stringify({ id: user_id }), (data) => {
    if (data) {
      const punishmentsData = $("#punishmentsData")

      const html = `
                <div class="punishments-list">
                    ${data.warnings
                      .filter(warning => warning.banned_real_time) // Mostrar apenas banimentos
                      .map(
                        (warning) => `
                        <div class="punishment-item">
                            <div class="punishment-info">
                                <div class="punishment-reason">${warning.reason}</div>
                                <div class="punishment-time">${warning.banned_real_time} dias</div>
                            </div>
                            <div class="punishment-actions">
                                ${perms["deleteban"] ? `
                                    <button class="btn-small btn-remove" onclick="deleteBan('${warning.id}', '${user_id}')">
                                        Deletar
                                    </button>
                                ` : ''}
                            </div>
                        </div>
                    `,
                      )
                      .join("")}
                    
                    <div class="punishment-actions-main">
                        <button class="btn-small btn-add" onclick="showBanModal('${user_id}')">
                            Aplicar Banimento
                        </button>
                    </div>
                </div>
            `

      punishmentsData.html(html)
    }
  })
}

function loadgroups() {
  const select = $("#cargoSelect")
  select.html('<option value="" disabled selected>Selecione um cargo...</option>')

  const sortedGroups = groups.sort((a, b) => a.name.localeCompare(b.name))

  sortedGroups.forEach((group) => {
    if (group.group !== "Admin") {
      select.append(`<option value="${group.group}">${group.name}</option>`)
    }
  })

  // Limpar níveis ao abrir o modal
  $("#nivelSelect").html('<option value="" disabled selected>Selecione o nível...</option>')
}

// Atualizar níveis ao selecionar um cargo
$(document).on("change", "#cargoSelect", function() {
  const groupKey = $(this).val()
  const groupObj = groups.find(g => g.group === groupKey)
  const nivelSelect = $("#nivelSelect")
  nivelSelect.html('<option value="" disabled selected>Selecione o nível...</option>')
  if (groupObj && groupObj.hierarchy && Array.isArray(groupObj.hierarchy)) {
    groupObj.hierarchy.forEach((nivel, idx) => {
      nivelSelect.append(`<option value="${idx+1}">${nivel}</option>`)
    })
  }
})

function showAddGroupModal(userId) {
  $("#cargoModal").show()
  $("#confirmCargo")
    .off("click")
    .on("click", () => {
      const group = $("#cargoSelect").val()
      const level = $("#nivelSelect").val()
      if (group && level) {
        addGroup(userId, group, level)
      }
    })
}

function addGroup(userId, group, level) {
  $.post("https://ps_staff/addgroup", JSON.stringify({ id: userId, group: group, level: level }), (data) => {
    if (data) {
      loaduserdata(userId)
      $("#cargoModal").hide()
      $.post("https://ps_staff/notify", JSON.stringify({ type: "verde", message: `Grupo adicionado com sucesso ao id #${userId}` }))
    } else {
      $.post("https://ps_staff/notify", JSON.stringify({ type: "vermelho", message: `Não foi possível adicionar o grupo ao id #${userId}` }))
    }
  })
}

function showBanModal(userId) {
  $("#banModal").show()
  $("#confirmBan")
    .off("click")
    .on("click", () => {
      const reason = $("#banReason").val()
      const time = Number.parseInt($("#banTime").val())
      if (reason.trim() && time > 0) {
        addBan(userId, time, reason)
      } else {
        createAlert("danger", "Erro", "Preencha o motivo e o tempo do banimento", 3000)
      }
    })
}

// API functions
function removeGroup(userId, group) {
  $.post("https://ps_staff/remgroup", JSON.stringify({ id: userId, group: group }), (data) => {
    if (data) {
      loaduserdata(userId)
      $.post("https://ps_staff/notify", JSON.stringify({ type: "verde", message: `Grupo removido com sucesso do id #${userId}` }))
    } else {
      $.post("https://ps_staff/notify", JSON.stringify({ type: "vermelho", message: `Não foi possível remover o grupo do id #${userId}` }))
    }
  })
}

function addBan(userId, time, reason) {
  $.post("https://ps_staff/addban", JSON.stringify({ id: userId, time: time, reason: reason }), (data) => {
    if (data) {
      loaduserwarnings(userId)
      $("#banModal").hide()
      $("#banTime").val("")
      $("#banReason").val("")
      $.post("https://ps_staff/notify", JSON.stringify({ type: "verde", message: `Player #${userId} foi banido com sucesso` }))
    } else {
      $.post("https://ps_staff/notify", JSON.stringify({ type: "vermelho", message: `Não foi possível banir o id #${userId}` }))
    }
  })
}

function deleteBan(banId, userId) {
  $.post("https://ps_staff/deleteban", JSON.stringify({ id: banId, user_id: userId }), (data) => {
    if (data) {
      loaduserwarnings(userId)
      $.post("https://ps_staff/notify", JSON.stringify({ type: "verde", message: `Banimento deletado com sucesso` }))
    } else {
      $.post("https://ps_staff/notify", JSON.stringify({ type: "vermelho", message: `Não foi possível deletar o banimento` }))
    }
  })
}



// Declare the loadchatmessages function
function loadchatmessages(messages) {
  // Implementation for loadchatmessages
  console.log("Loading chat messages:", messages)
}

// Chat Staff Functions (VERSÕES CORRIGIDAS)
let chatStaffMessages = []

// Função para abrir o chat staff
function openChatStaff() {
  console.log("Abrindo Chat Staff...") // Debug

  // Mostrar o modal
  $("#chatStaffModal").show()

  // Focar no input
  setTimeout(() => {
    $("#chatStaffInput").focus()
  }, 100)

  // Carregar mensagens existentes do servidor
  $.post("https://ps_staff/getchatstaffmessages", JSON.stringify({}), (data) => {
    if (data && data.messages) {
      chatStaffMessages = data.messages
      renderChatStaffMessages()
    }
  }).fail(() => {
    console.log("Não foi possível carregar mensagens do servidor")
    // Carregar mensagens de exemplo se falhar
    chatStaffMessages = [
      {
        message: "Bem-vindo ao chat com a equipe! Digite sua mensagem abaixo.",
        is_staff: true,
        sender_name: "Sistema",
        timestamp: new Date().toISOString(),
      },
    ]
    renderChatStaffMessages()
  })

  console.log("Chat Staff aberto!") // Debug
}

// Função para fechar o chat staff
function closeChatStaff() {
  $("#chatStaffModal").hide()
}

// Função para carregar mensagens do chat staff do servidor
function loadChatStaffMessages(messages) {
  if (messages && Array.isArray(messages)) {
    chatStaffMessages = messages
    renderChatStaffMessages()
  }
}

// Função para renderizar mensagens do chat staff
function renderChatStaffMessages() {
  const container = $("#chatStaffMessages")

  // Limpar container
  container.html("")

  // Adicionar mensagem de boas-vindas se não houver mensagens
  if (chatStaffMessages.length === 0) {
    const welcomeHtml = `
      <div class="welcome-message">
        <div class="chat-message system">
          <i class="fas fa-info-circle"></i>
          Bem-vindo ao chat com a equipe! Digite sua mensagem abaixo e aguarde uma resposta.
        </div>
      </div>
    `
    container.append(welcomeHtml)
  } else {
    // Adicionar mensagens
    chatStaffMessages.forEach((message) => {
      const messageClass = message.is_staff ? "staff" : "user"
      const senderName = message.is_staff ? `Staff ${message.sender_name}` : "Você"
      const time = new Date(message.timestamp).toLocaleTimeString("pt-BR", {
        hour: "2-digit",
        minute: "2-digit",
      })

      const messageHtml = `
        <div class="chat-message ${messageClass}">
          <div class="message-content">${message.message}</div>
          <div class="message-info">${senderName} - ${time}</div>
        </div>
      `

      container.append(messageHtml)
    })
  }

  // Scroll para baixo
  setTimeout(() => {
    container.scrollTop(container[0].scrollHeight)
  }, 100)
}

// Função para enviar mensagem no chat staff
function sendChatStaffMessage() {
  const messageText = $("#chatStaffInput").val().trim()

  if (messageText.length === 0 || messageText.length > 500) {
    return
  }

  // Enviar mensagem para o servidor
  $.post("https://ps_staff/sendchatstaffmessage", JSON.stringify({ message: messageText }), (result) => {
    if (result && result.success) {
      // Limpar input
      $("#chatStaffInput").val("")
      $("#charCount").text("0")

      // Adicionar mensagem localmente
      const newMessage = {
        message: messageText,
        is_staff: false,
        sender_name: "Você",
        timestamp: new Date().toISOString(),
      }

      chatStaffMessages.push(newMessage)
      renderChatStaffMessages()
    } else {
      console.log("Erro ao enviar mensagem:", result)
    }
  }).fail(() => {
    console.log("Falha na comunicação com o servidor")
  })
}

// Função para receber nova mensagem do chat staff
function receiveChatStaffMessage(messageData) {
  if (messageData && typeof messageData === "object") {
    chatStaffMessages.push(messageData)
    renderChatStaffMessages()
  }
}

// Funções de teste (pode remover depois)
function testChatStaff() {
  console.log("Testando Chat Staff...")
  openChatStaff()
}

// Expor funções globalmente para debug
window.testChatStaff = testChatStaff
window.openChatStaff = openChatStaff

function loadvehicles() {
  const container = $("#vehiclesGrid")
  container.html("")

  const sortedVehicles = vehicles.sort((a, b) => a.name.localeCompare(b.name))

  sortedVehicles.forEach((vehicle) => {
    // Montar caminho da imagem igual ao garages
    const model = vehicle.vehicle || vehicle.model;
    const imageUrl = `nui://vrp/config/garages/${model}.png`;
    const fallbackUrl = 'nui://garages/web-side/js/noimage.png';
    const $card = $(`
      <div class="vehicle-card" data-vehicle="${model}">
        <div class="vehicle-image-placeholder"></div>
        <div class="name">${vehicle.name}</div>
      </div>
    `);
    container.append($card);
    const $placeholder = $card.find('.vehicle-image-placeholder');
    // Carregar imagem com fallback
    const testImg = new Image();
    testImg.onload = function() {
      $placeholder.css({
        'background-image': `url('${imageUrl}')`,
        'background-size': 'contain',
        'background-repeat': 'no-repeat',
        'background-position': 'center',
        'background-color': '#fff',
        'border': 'none',
        'width': '64px',
        'height': '64px',
        'margin': '0 auto 8px auto'
      });
      $placeholder.html('');
    };
    testImg.onerror = function() {
      $placeholder.css({
        'background-image': `url('${fallbackUrl}')`,
        'background-size': 'contain',
        'background-repeat': 'no-repeat',
        'background-position': 'center',
        'background-color': '#f0f0f0',
        'border': '2px dashed #ccc',
        'width': '64px',
        'height': '64px',
        'margin': '0 auto 8px auto'
      });
      $placeholder.html('<i class="fas fa-car" style="color: #999; font-size: 20px;"></i>');
    };
    testImg.src = imageUrl;
  })
}

function slugify(str) {
  return str
    .normalize('NFD').replace(/[ -]/g, '') // remove acentos
    .replace(/[^a-zA-Z0-9]/g, '_') // troca caracteres especiais por _
    .replace(/_+/g, '_') // múltiplos _ por um só
    .replace(/^_+|_+$/g, '') // remove _ do início/fim
    .toLowerCase();
}

function loaditems() {
  const containers = ["#itemsGridOther"];

  containers.forEach((container) => {
    $(container).html("");

    const sortedItems = items.sort((a, b) => a.name.localeCompare(b.name));

    sortedItems.forEach((item) => {
      // Se existir item.Index, usar ele como nome do arquivo da imagem
      let candidates = [];
      if (item.Index) {
        candidates.push(item.Index);
      }
      // Fallbacks caso não exista Index
      candidates = candidates.concat([
        item.item,
        slugify(item.item),
        slugify(item.name),
        item.item.toLowerCase(),
        item.item.replace(/ /g, '_').toLowerCase(),
        item.item.replace(/ /g, '').toLowerCase(),
      ]);
      let imageUrl = '';
      let tried = 0;
      // Corrigir: garantir que data-item seja sempre string (nome técnico do item)
      const $card = $(`
        <div class="item-card" data-item="${item.item}" title="${item.name}">
          <div class="item-image-placeholder"></div>
          <div class="name">${item.name}</div>
        </div>
      `);
      $(container).append($card);
      const $placeholder = $card.find('.item-image-placeholder');
      function tryNext() {
        if (tried >= candidates.length) {
          $placeholder.css({
            'background-image': 'none',
            'background-color': '#f0f0f0',
            'border': '2px dashed #ccc'
          });
          $placeholder.html('<i class="fas fa-image" style="color: #999; font-size: 20px;"></i>');
          return;
        }
        imageUrl = `nui://vrp/config/inventory/${candidates[tried]}.png`;
        const testImg = new Image();
        testImg.onload = function() {
          $placeholder.css({
            'background-image': `url('${imageUrl}')`,
            'background-size': 'contain',
            'background-repeat': 'no-repeat',
            'background-position': 'center',
            'background-color': '#fff',
            'border': 'none'
          });
          $placeholder.html('');
        };
        testImg.onerror = function() {
          tried++;
          tryNext();
        };
        testImg.src = imageUrl;
      }
      tryNext();
    });
  });
}

function formatCurrency(value) {
  return new Intl.NumberFormat("pt-BR", {
    style: "currency",
    currency: "BRL",
  }).format(value)
}

// Variáveis globais para o sistema de scroll infinito do inventário
let currentInventoryPage = 0
let inventoryItemsPerPage = 20
let allInventoryItems = []
let currentInventoryUserId = null



// Função para renderizar inventário com paginação
function renderInventoryPage(items, page = 0) {
  console.log("Renderizando página do inventário:", page)
  console.log("Total de itens:", items.length)
  console.log("Estrutura do primeiro item:", items[0])
  
  const startIndex = page * inventoryItemsPerPage
  const endIndex = startIndex + inventoryItemsPerPage
  const pageItems = items.slice(startIndex, endIndex)
  
  console.log("Itens desta página:", pageItems.length)
  
  const container = $('#playerInventoryGrid')
  
  if (page === 0) {
    container.html('')
  }
  
  if (pageItems.length === 0) {
    if (page === 0) {
      container.html('<div class="inventory-empty">Inventário vazio</div>')
    }
    return
  }
  
  // Criar cards e carregar imagens individualmente (igual ao Spawn Itens)
  pageItems.forEach((item) => {
    console.log("Processando item:", item)
    
    // Determinar nome e quantidade baseado na estrutura do item
    let itemName = item.name || item.item || 'Item Desconhecido'
    let itemAmount = item.amount || item.quantidade || 1
    let itemIndex = item.Index || item.index || item.item
    
    // Se existir item.Index, usar ele como nome do arquivo da imagem
    let candidates = []
    if (itemIndex) {
      candidates.push(itemIndex)
    }
    // Fallbacks caso não exista Index
    candidates = candidates.concat([
      item.item,
      slugify(item.item),
      slugify(itemName),
      item.item ? item.item.toLowerCase() : '',
      item.item ? item.item.replace(/ /g, '_').toLowerCase() : '',
      item.item ? item.item.replace(/ /g, '').toLowerCase() : '',
    ]).filter(candidate => candidate && candidate !== '')
    
    let imageUrl = ''
    let tried = 0
    
    // Criar o card (igual ao Spawn Itens)
    const $card = $(`
      <div class="inventory-item" title="${itemName} - Quantidade: ${itemAmount}" data-item="${item.item || ''}">
        <div class="item-image-placeholder"></div>
        <div class="item-info">
          <div class="item-name">${itemName}</div>
          <div class="item-amount">${itemAmount}x</div>
        </div>
      </div>
    `)
    
    container.append($card)
    const $placeholder = $card.find('.item-image-placeholder')
    
    function tryNext() {
      if (tried >= candidates.length) {
        $placeholder.css({
          'background-image': 'none',
          'background-color': '#f0f0f0',
          'border': '2px dashed #ccc'
        })
        $placeholder.html('<i class="fas fa-image" style="color: #999; font-size: 16px;"></i>')
        return
      }
      
      imageUrl = `nui://vrp/config/inventory/${candidates[tried]}.png`
      const testImg = new Image()
      
      testImg.onload = function() {
        $placeholder.css({
          'background-image': `url('${imageUrl}')`,
          'background-size': 'contain',
          'background-repeat': 'no-repeat',
          'background-position': 'center',
          'background-color': '#fff',
          'border': 'none'
        })
        $placeholder.html('')
      }
      
      testImg.onerror = function() {
        tried++
        tryNext()
      }
      
      testImg.src = imageUrl
    }
    
    tryNext()
  })
}

// Função para carregar mais itens do inventário
function loadMoreInventoryItems() {
  if (allInventoryItems.length > (currentInventoryPage + 1) * inventoryItemsPerPage) {
    // Adicionar indicador de carregamento
    const container = $('#playerInventoryGrid')
    const loadingHtml = '<div class="inventory-loading">Carregando mais itens...</div>'
    container.append(loadingHtml)
    
    // Simular delay para melhor UX
    setTimeout(() => {
      currentInventoryPage++
      renderInventoryPage(allInventoryItems, currentInventoryPage)
    }, 300)
  }
}



// Função de fallback para renderização simples do inventário
function renderSimpleInventory(inventory) {
  console.log("Usando renderização simples do inventário")
  
  const container = $('#playerInventoryGrid')
  container.html('')
  
  if (!inventory || inventory.length === 0) {
    container.html('<div class="inventory-empty">Inventário vazio</div>')
    return
  }
  
  inventory.forEach((item, index) => {
    let itemName = 'Item Desconhecido'
    let itemAmount = 1
    
    // Tentar extrair informações do item
    if (typeof item === 'string') {
      itemName = item
    } else if (typeof item === 'object') {
      itemName = item.name || item.item || item.nome || 'Item Desconhecido'
      itemAmount = item.amount || item.quantidade || item.qtd || 1
    }
    
    const $card = $(`
      <div class="inventory-item" title="${itemName} - Quantidade: ${itemAmount}">
        <div class="item-image-placeholder">
          <i class="fas fa-cube" style="color: #999; font-size: 16px;"></i>
        </div>
        <div class="item-info">
          <div class="item-name">${itemName}</div>
          <div class="item-amount">${itemAmount}x</div>
        </div>
      </div>
    `)
    
    container.append($card)
  })
}

// Função para normalizar estrutura do inventário
function normalizeInventoryData(inventory) {
  console.log("Normalizando dados do inventário:", inventory)
  
  if (!inventory || !Array.isArray(inventory)) {
    console.log("Inventário inválido ou não é array")
    return []
  }
  
  return inventory.map(item => {
    // Se o item já tem a estrutura correta, retornar como está
    if (item.name && (item.amount !== undefined || item.quantidade !== undefined)) {
      return {
        name: item.name,
        amount: item.amount || item.quantidade || 1,
        item: item.item || item.name,
        Index: item.Index || item.index || item.item
      }
    }
    
    // Se é uma string (formato antigo), converter
    if (typeof item === 'string') {
      return {
        name: item,
        amount: 1,
        item: item,
        Index: item
      }
    }
    
    // Se é um objeto com estrutura diferente, tentar adaptar
    if (typeof item === 'object') {
      return {
        name: item.name || item.item || item.nome || 'Item Desconhecido',
        amount: item.amount || item.quantidade || item.qtd || 1,
        item: item.item || item.name || item.nome || 'Item Desconhecido',
        Index: item.Index || item.index || item.item || item.name || item.nome
      }
    }
    
    // Fallback
    return {
      name: 'Item Desconhecido',
      amount: 1,
      item: 'unknown',
      Index: 'unknown'
    }
  })
}

// Função para inicializar o inventário com scroll infinito
function initializeInventoryScroll(userId, inventory) {
  console.log("Inicializando inventário para user:", userId)
  console.log("Dados do inventário originais:", inventory)
  
  // Normalizar os dados do inventário
  const normalizedInventory = normalizeInventoryData(inventory)
  console.log("Dados do inventário normalizados:", normalizedInventory)
  
  currentInventoryUserId = userId
  allInventoryItems = normalizedInventory
  currentInventoryPage = 0
  
  // Renderizar primeira página
  renderInventoryPage(allInventoryItems, 0)
  
  // Mostrar informações sobre o scroll infinito se houver muitos itens
  if (allInventoryItems.length > inventoryItemsPerPage) {
    const container = $('#playerInventoryGrid')
    const infoHtml = `<div class="inventory-info">Mostrando ${inventoryItemsPerPage} de ${allInventoryItems.length} itens. Role para ver mais.</div>`
    container.prepend(infoHtml)
  }
  
  // Configurar scroll infinito
  const container = $('#playerInventoryGrid')
  container.off('scroll.inventory') // Remover listeners anteriores
  
  container.on('scroll.inventory', function() {
    const scrollTop = $(this).scrollTop()
    const scrollHeight = $(this)[0].scrollHeight
    const clientHeight = $(this)[0].clientHeight
    
    // Carregar mais itens quando chegar próximo ao final
    if (scrollTop + clientHeight >= scrollHeight - 50) {
      loadMoreInventoryItems()
    }
  })
}

function updateOnlinePlayers() {
  $.post('https://ps_staff/getOnlinePlayers', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlinePlayersNumber").text(data.count)
    } else {
      $("#onlinePlayersNumber").text("-")
    }
  }, 'json')
}

function updateOnlineStaff() {
  $.post('https://ps_staff/getOnlineStaff', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlineStaffNumber").text(data.count)
    } else {
      $("#onlineStaffNumber").text("-")
    }
  }, 'json')
}

function updateOnlinePolice() {
  $.post('https://ps_staff/getOnlinePolice', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlinePoliceNumber").text(data.count)
    } else {
      $("#onlinePoliceNumber").text("-")
    }
  }, 'json')
}

function updateOnlinePRF() {
  $.post('https://ps_staff/getOnlinePRF', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlinePRFNumber").text(data.count)
    } else {
      $("#onlinePRFNumber").text("-")
    }
  }, 'json')
}

function updateOnlinePCivil() {
  $.post('https://ps_staff/getOnlinePCivil', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlinePCivilNumber").text(data.count)
    } else {
      $("#onlinePCivilNumber").text("-")
    }
  }, 'json')
}

function updateOnlineCore() {
  $.post('https://ps_staff/getOnlineCore', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlineCoreNumber").text(data.count)
    } else {
      $("#onlineCoreNumber").text("-")
    }
  }, 'json')
}

function updateOnlineOficina01() {
  $.post('https://ps_staff/getOnlineOficina01', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlineOficina01Number").text(data.count)
    } else {
      $("#onlineOficina01Number").text("-")
    }
  }, 'json')
}

function updateOnlineOficina012() {
  $.post('https://ps_staff/getOnlineOficina012', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlineOficina012Number").text(data.count)
    } else {
      $("#onlineOficina012Number").text("-")
    }
  }, 'json')
}

function updateOnlineHarmony() {
  $.post('https://ps_staff/getOnlineHarmony', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlineHarmonyNumber").text(data.count)
    } else {
      $("#onlineHarmonyNumber").text("-")
    }
  }, 'json')
}

function updateOnlineJudiciary() {
  $.post('https://ps_staff/getOnlineJudiciary', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlineJudiciaryNumber").text(data.count)
    } else {
      $("#onlineJudiciaryNumber").text("-")
    }
  }, 'json')
}

function updateOnlineParamedic() {
  $.post('https://ps_staff/getOnlineParamedic', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlineParamedicNumber").text(data.count)
    } else {
      $("#onlineParamedicNumber").text("-")
    }
  }, 'json')
}

function updateOnlineBurgerShot() {
  $.post('https://ps_staff/getOnlineBurgerShot', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlineBurgerShotNumber").text(data.count)
    } else {
      $("#onlineBurgerShotNumber").text("-")
    }
  }, 'json')
}

function updateOnlinePearls() {
  $.post('https://ps_staff/getOnlinePearls', {}, function(data) {
    if(data && data.count !== undefined) {
      $("#onlinePearlsNumber").text(data.count)
    } else {
      $("#onlinePearlsNumber").text("-")
    }
  }, 'json')
}

// Atualizar todos juntos ao abrir o dashboard
function updateAllOnlineGroups() {
  updateOnlinePlayers();
  updateOnlineStaff();
  updateOnlinePolice();
  updateOnlinePRF();
  updateOnlinePCivil();
  updateOnlineCore();
  updateOnlineOficina01();
  updateOnlineOficina012();
  updateOnlineHarmony();
  updateOnlineJudiciary();
  updateOnlineParamedic();
  updateOnlineBurgerShot();
  updateOnlinePearls();
}

// Lista de grupos para os cards
const orgGroups = [
    { id: 'orgPolice', group: 'Police' },
    { id: 'orgPRF', group: 'PRF' },
    { id: 'orgPCivil', group: 'PCivil' },
    { id: 'orgCore', group: 'Core' },
    { id: 'orgOficina01', group: 'Oficina01' },
    { id: 'orgOficina012', group: 'Oficina02' },
    { id: 'orgHarmony', group: 'Harmony' },
    { id: 'orgJudiciary', group: 'Judiciary' },
    { id: 'orgParamedic', group: 'Paramedic' },
    { id: 'orgBurgerShot', group: 'BurgerShot' },
    { id: 'orgPearls', group: 'Pearls' },
    { id: 'orgPlayboy', group: 'Playboy' },
    { id: 'orgMadrazzo', group: 'Madrazzo' },
    { id: 'orgTheSouth', group: 'TheSouth' },
    { id: 'orgVineyard', group: 'Vineyard' },
    { id: 'orgBarragem', group: 'Barragem' },
    { id: 'orgFarol', group: 'Farol' },
    { id: 'orgParque', group: 'Parque' },
    { id: 'orgSandy', group: 'Sandy' },
    { id: 'orgPetroleo', group: 'Petroleo' },
    { id: 'orgPraia1', group: 'Praia-1' },
    { id: 'orgPraia2', group: 'Praia-2' },
    { id: 'orgZancudo', group: 'Zancudo' },
    { id: 'orgChiliad', group: 'Chiliad' },
    { id: 'orgVagos', group: 'Vagos' }
];

// Função genérica para renderizar card de organização
function renderOrgCard(cardId, group) {
    const card = $('#' + cardId);
    const details = card.find('.org-card-details');
    const membersCount = card.find('.org-card-members');
    $.post('https://ps_staff/getGroupMembers', JSON.stringify({ group }), function(members) {
        if (members && members.length > 0) {
            let html = '<div class="inventory-grid list-view">';
            members.forEach(member => {
                const statusClass = member.online ? 'online' : 'offline';
                const statusText = member.online ? 'Online' : 'Offline';
                html += `<div class="inventory-item" title="${member.name} (ID: ${member.id || member.user_id})">
                    <div class="item-image-placeholder"><i class="fas fa-user" style="color: #999; font-size: 16px;"></i></div>
                    <div class="item-info">
                        <div class="item-name">${member.name} <span style='color:#888;font-size:11px;'>#${member.id || member.user_id}</span></div>
                        <div class="item-amount ${statusClass}" style="font-size:12px;">${statusText}</div>
                    </div>
                </div>`;
            });
            html += '</div>';
            if(card.attr('open')) {
                details.html(html);
                details.stop(true,true).slideDown(180);
            }
            membersCount.text(`(${members.length} membros)`);
        } else {
            if(card.attr('open')) {
                details.html('<div class="inventory-grid list-view"><div class="inventory-item">Nenhum membro encontrado</div></div>');
                details.stop(true,true).slideDown(180);
            }
            membersCount.text('(0 membros)');
        }
    });
}

// Atualizar todos os cards de organizações
function updateAllOrgCards() {
    renderOrgCard('orgStaff', 'Admin');
    renderOrgCard('orgPolice', 'Police');
    renderOrgCard('orgPRF', 'PRF');
    renderOrgCard('orgPCivil', 'PCivil');
    renderOrgCard('orgCore', 'Core');
    renderOrgCard('orgOficina01', 'Oficina01');
    renderOrgCard('orgOficina012', 'Oficina02');
    renderOrgCard('orgHarmony', 'Harmony');
    renderOrgCard('orgJudiciary', 'Judiciary');
    renderOrgCard('orgParamedic', 'Paramedic');
    renderOrgCard('orgBurgerShot', 'BurgerShot');
    renderOrgCard('orgPearls', 'Pearls');
    renderOrgCard('orgPlayboy', 'Playboy');
    renderOrgCard('orgMadrazzo', 'Madrazzo');
    renderOrgCard('orgTheSouth', 'TheSouth');
    renderOrgCard('orgVineyard', 'Vineyard');
    renderOrgCard('orgBarragem', 'Barragem');
    renderOrgCard('orgFarol', 'Farol');
    renderOrgCard('orgParque', 'Parque');
    renderOrgCard('orgSandy', 'Sandy');
    renderOrgCard('orgPetroleo', 'Petroleo');
    renderOrgCard('orgPraia1', 'Praia-1');
    renderOrgCard('orgPraia2', 'Praia-2');
    renderOrgCard('orgZancudo', 'Zancudo');
    renderOrgCard('orgChiliad', 'Chiliad');
    renderOrgCard('orgVagos', 'Vagos');
}

// ============================================================================
// FUNÇÕES DE BUSCA DE ITENS
// ============================================================================

// Função para buscar itens
function searchItems(searchTerm) {
  console.log("Buscando itens com termo:", searchTerm)
  
  $.post("https://ps_staff/searchitems", JSON.stringify({ searchTerm: searchTerm }), (data) => {
    if (data && data.length > 0) {
      console.log("Itens encontrados:", data)
      displaySearchResults(data)
    } else {
      console.log("Nenhum item encontrado")
      displaySearchResults([])
    }
  })
}

// Função para obter informações de um item específico
function getItemInfo(itemId) {
  console.log("Obtendo informações do item:", itemId)
  
  $.post("https://ps_staff/getiteminfo", JSON.stringify({ itemId: itemId }), (data) => {
    if (data) {
      console.log("Informações do item:", data)
      return data
    } else {
      console.log("Item não encontrado")
      return null
    }
  })
}

// Função para exibir resultados da busca
function displaySearchResults(results) {
  const container = $('#searchResults')
  if (container.length === 0) {
    console.log("Container de resultados não encontrado")
    return
  }
  
  let html = ''
  
  if (results.length === 0) {
    html = '<div class="no-results">Nenhum item encontrado</div>'
  } else {
    results.forEach(item => {
      html += `
        <div class="search-result-item" onclick="selectItem('${item.item}')">
          <div class="item-info">
            <div class="item-name">${item.name}</div>
            <div class="item-id">ID: ${item.item}</div>
          </div>
        </div>
      `
    })
  }
  
  container.html(html)
}

// Função para selecionar um item da busca
function selectItem(itemId) {
  console.log("Item selecionado:", itemId)
  
  // Preencher o campo de busca com o item selecionado
  $('#itemSearch').val(itemId)
  
  // Limpar resultados
  $('#searchResults').html('')
  
  // Focar no campo de quantidade
  $('#itemAmount').focus()
}

// Função para mostrar modal de busca de itens
function showItemSearchModal() {
  // Criar modal dinamicamente se não existir
  if ($('#itemSearchModal').length === 0) {
    const modalHtml = `
      <div id="itemSearchModal" class="modal-overlay">
        <div class="modal-content">
          <div class="modal-header">
            <h3>Buscar Itens</h3>
            <button class="modal-close" onclick="$('#itemSearchModal').hide()">&times;</button>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label for="itemSearch">Buscar item:</label>
              <input type="text" id="itemSearch" class="form-control" placeholder="Digite o nome ou ID do item...">
            </div>
            <div id="searchResults" class="search-results"></div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-secondary" onclick="$('#itemSearchModal').hide()">Fechar</button>
          </div>
        </div>
      </div>
    `
    $('body').append(modalHtml)
    
    // Adicionar evento de busca em tempo real
    $('#itemSearch').on('input', function() {
      const searchTerm = $(this).val()
      if (searchTerm.length >= 2) {
        searchItems(searchTerm)
      } else {
        $('#searchResults').html('')
      }
    })
  }
  
  // Mostrar modal
  $('#itemSearchModal').show()
  $('#itemSearch').focus()
}

// ============================================================================
// FUNÇÕES DE INVENTÁRIO REAL
// ============================================================================

// Função para buscar inventário de um player específico
function getUserInventory(userId) {
  console.log("Buscando inventário do player:", userId)
  
  $.post("https://ps_staff/getuserinventory", JSON.stringify({ userId: userId }), (data) => {
    if (data && data.length >= 0) {
      console.log("Inventário recebido:", data)
      displayUserInventory(data, userId)
    } else {
      console.log("Erro ao buscar inventário")
      displayUserInventory([], userId)
    }
  })
}

// Função para exibir inventário do usuário
function displayUserInventory(inventory, userId) {
  const container = $('#playerInventoryGrid')
  if (container.length === 0) {
    console.log("Container de inventário não encontrado")
    return
  }
  
  console.log("Exibindo inventário para player", userId, "com", inventory.length, "itens")
  
  if (inventory.length === 0) {
    container.html('<div class="inventory-empty">Nenhum item encontrado</div>')
    return
  }
  
  let html = ''
  inventory.forEach((item, index) => {
    console.log("Processando item:", item)
    
    // Verificar se tem imagem
    const hasImage = item.image && item.image !== config.UserImage
    const imageHtml = hasImage ? 
      `<img src="${item.image}" alt="${item.name}" class="item-image" onerror="this.style.display='none'; this.nextElementSibling.style.display='block';">` :
      ''
    
    html += `
      <div class="inventory-item" title="${item.name || 'Item desconhecido'}">
        <div class="item-image-placeholder">
          ${imageHtml}
          <i class="fas fa-box" style="color: #999; font-size: 16px; ${hasImage ? 'display: none;' : 'display: block;'}"></i>
        </div>
        <div class="item-info">
          <div class="item-name">${item.name || 'Item desconhecido'}</div>
          <div class="item-amount">x${item.amount || 0}</div>
          ${item.peso ? `<div class="item-details"><small>Peso: ${item.peso}kg</small></div>` : ''}
          ${item.durability > 0 ? `<div class="item-details"><small>Durabilidade: ${item.durability} dias</small></div>` : ''}
          ${item.economy ? `<div class="item-details"><small>Valor: ${item.economy}</small></div>` : ''}
        </div>
      </div>
    `
  })
  
  container.html(html)
  console.log("Inventário renderizado com sucesso")
}

// Função para atualizar inventário em tempo real
function refreshUserInventory(userId) {
  if (userId) {
    getUserInventory(userId)
  }
}