include ActionView::Helpers::NumberHelper
include ActionView::Helpers::AssetTagHelper
class CalculosController < ApplicationController
  respond_to :docx
  skip_before_filter :verify_authenticity_token 

  # GET /boats
  # GET /boats.json
  def index    
  
  end
  def ejemplo
    @fecha = params[:field1].to_s
    @fecha_split = @fecha.split('-')
    @mes_antes = @fecha_split.first
    @mes = @fecha_split.first.to_i
    @agno = @fecha_split.second.to_i.to_s
    @meses_agno = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
    @mes_salida = @meses_agno[(@mes-1)]
    @model = Trip.joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on products.id = summaries.product_id").select("products.nombre as nombre_producto, providers.nombre as nombre_proveedor, trips.salida as fechasalida, costs.alimentacion as alimentacion, costs.combustible as combustible, costs.personal as personal, costs.emergencia as emergencia, ships.nombre as nombre_embarcacion, summaries.cantidad as cantidad, summaries.precio as precio, summaries.cantidad as cantidad")
    @boats = @model.where("extract(year from salida) = ? and extract(month from salida) = ?", @agno, @mes_antes)
    @model_ventas = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id join clients on clients.id = sales.client_id").select("*")
    @ventas = @model_ventas.where("extract(year from fecha) = ? and extract(month from fecha) = ?", @agno, @mes_antes)
  end
  def reporteY
    #Sacar variables de fechas del fomr
    @fecha_inicio = params[:inicio].to_s
    @fecha_fin = params[:fin].to_s
    #Mes y año para fecha inicio
    @fecha_split_inicio = @fecha_inicio.split('-')
    @mes_antes_inicio = @fecha_split_inicio.first
    @mes_inicio = @fecha_split_inicio.first.to_i
    @agno_inicio = @fecha_split_inicio.second.to_i.to_s
    @agno_i = @fecha_split_inicio.second.to_i
    #Mes y año para fecha fin
    @fecha_split_fin = @fecha_fin.split('-')
    @mes_antes_fin = @fecha_split_fin.first
    @mes_fin = @fecha_split_fin.first.to_i
    @agno_fin = @fecha_split_fin.second.to_i.to_s
    @agno_f = @fecha_split_fin.second.to_i
    if (@agno_inicio > @agno_fin)
       redirect_to :action => "index", :notice => "¡Error! La selección de rango de fechas no es válida." 
      #redirect_to(show_path, {:flash => { :error => "Insufficient rights!" }})
    else
      if(@agno_inicio == @agno_fin)
        if(@mes_inicio > @mes_fin)          
          redirect_to :action => "index", :notice => "¡Error! La selección de rango de fechas no es válida." 
        end
      end
      aux = @agno_f - @agno_i
      if(aux > 1)
        redirect_to :action => "index", :notice => "¡Error! La selección de rango debe ser máximo hasta 2 años." 
      end
    end
    #Consulta BD para calculo por productos entre fechas seleccionadas
    if(@agno_inicio == @agno_fin)
      @resumen = Trip.joins("join costs on costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("products.nombre, sum(costs.alimentacion + costs.combustible + costs.personal + costs.emergencia) as inversion, SUM(summaries.cantidad) as cantidad, SUM(summaries.precio*summaries.cantidad) as precio").group("products.nombre")
      @boats = @resumen.where("(extract(year from salida) >= ? AND extract(month from salida) >= ?) AND (extract(year from salida) <= ? AND extract(month from salida) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin)
      @model_ventas = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id").select("products.nombre, sum(details.precio * details.cantidad) as valor").group("products.nombre")
      @ventas = @model_ventas.where("(extract(year from fecha) >= ? and extract(month from fecha) >= ?) AND (extract(year from fecha) <= ? and extract(month from fecha) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin)
      #Calculos por meses seleccionados (Ej: Enero - Marzo (2016))
      @model1 = Trip.joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("trips.salida as salida, products.nombre as nombre, providers.nombre as nombre_proveedor, summaries.cantidad as cantidad, (summaries.precio * summaries.cantidad) as valor_invertido, trips.ship_id as embarcaciones_id,  costs.alimentacion, costs.combustible, costs.personal, costs.emergencia, ships.nombre as nombre_embarcacion").order("salida ASC")
      @boats3 = @model1.where("(extract(year from salida) >= ? and extract(month from salida) >= ?) AND (extract(year from salida) <= ? and extract(month from salida) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin)
      @model_ventas1 = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id join clients on clients.id = sales.client_id").select("sales.fecha as fecha, products.nombre as nombre, clients.nombre as cliente_nombre, details.precio as valor_venta, details.cantidad as cantidad").order("fecha ASC")
      @ventas3 = @model_ventas1.where("(extract(year from fecha) >= ? and extract(month from fecha) >= ?) AND (extract(year from fecha) <= ? and extract(month from fecha) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin)
      #Consulta para grafico mas vendido
      @model1 = Trip.where("(extract(year from salida) >= ? and extract(month from salida) >= ?) AND (extract(year from salida) <= ? and extract(month from salida) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin).joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").group("products.nombre").sum("(summaries.precio * summaries.cantidad) + costs.alimentacion + costs.combustible + costs.personal + costs.emergencia")
      aux_md1 = 0
      @entro_md1 = false
      @model1.each do |model|
        aux_md1 = aux_md1 + 1
      end
      if(aux_md1 > 0)
        @entro_md1 = true
      else
        @xd = {"None" => 100}
      end

      #Consulta para grafico de mes con mas ganancia
      @model2 = Sale.order("to_char(fecha,'Mon-YY') DESC").where("(extract(year from fecha) >= ? and extract(month from fecha) >= ?) AND (extract(year from fecha) <= ? and extract(month from fecha) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin).joins("join details on details.sale_id = sales.id").group("to_char(fecha,'Mon-YY')").sum("(details.cantidad * details.precio)")
      aux_md2 = 0
      @entro_md2 = false
      @model2.each do |model|
        aux_md2 = aux_md2 + 1
      end
      if(aux_md2 > 0)
        @entro_md2 = true
      else
        @xd2 = {"None" => 100}
      end
      #@model3 = Venta.group("to_char(fecha,'Mon-YY')").sum("(ventas.cantidad * ventas.valor)")
      @meses_agno = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
      #Calculo de meses seleccionados
      @count_meses = (@agno_f * 12 + @mes_fin) - (@agno_i* 12 + @mes_inicio)
      @count_m = @count_meses.to_i
      @meses_agno = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre','Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
      #Gastos por meses
      @count = 0
      @gastos = Array.new(24, 0)
      agno_anterior = @agno_i
      @boats3.each do |gastos|
        fecha = gastos.salida.to_s
        fecha_split = fecha.split('-')
        mes = fecha_split.second.to_i
        agno = fecha_split.first.to_i
        if(agno_anterior != agno)
          mes = mes + 12
        end
        @gastos[mes-1] += (gastos.valor_invertido + gastos.alimentacion + gastos.combustible + gastos.personal + gastos.emergencia)
      end
      #Ganacia por meses
      @count = 0
      @ganancia = Array.new(24, 0)
      agno_anterior = @agno_i
      entro1 = false
      @ventas3.each do |gan|
        entro1 = true
        fecha = gan.fecha.to_s
        fecha_split = fecha.split('-')
        mes = fecha_split.second.to_i
        agno = fecha_split.first.to_i
        if(agno_anterior != agno)
          mes = mes + 12
        end
        @ganancia[mes-1] += gan.valor_venta * gan.cantidad
      end
      if(entro1 == false)
        for i in 0..23
          @ganancia[i] = 0
        end
      end
    else
      #Consulta 1
      @resumen1 = Trip.joins("join costs on costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("products.nombre, sum(costs.alimentacion + costs.combustible + costs.personal + costs.emergencia) as inversion, SUM(summaries.cantidad) as cantidad, SUM(summaries.precio*summaries.cantidad) as precio").group("products.nombre")
      @boats1 = @resumen1.where("extract(year from salida) = ? AND extract(month from salida) >= ?", @agno_inicio, @mes_antes_inicio)
      #Consulta 2
      @resumen2 = Trip.joins("join costs on costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("products.nombre, sum(costs.alimentacion + costs.combustible + costs.personal + costs.emergencia) as inversion, SUM(summaries.cantidad) as cantidad, SUM(summaries.precio*summaries.cantidad) as precio").group("products.nombre")
      @boats2 = @resumen2.where("extract(year from salida) = ? AND extract(month from salida) <= ?", @agno_fin, @mes_antes_fin)
      @boats1.each do |boats1|
        @boats2.each do |boats2|
          if(boats1.nombre == boats2.nombre)
            boats1.inversion = boats1.inversion + boats2.inversion
            boats1.cantidad = boats1.cantidad + boats2.cantidad
            boats1.precio = boats1.precio + boats2.precio
            boats2.nombre = ''
            boats2.inversion = nil
            boats2.cantidad = nil
            boats2.precio = nil
          end
        end
      end
      @boats = @boats1 + @boats2
      #Consulta 1
      @model_ventas1 = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id").select("products.nombre, sum(details.precio * details.cantidad) as valor").group("products.nombre")
      @ventas1 = @model_ventas1.where("extract(year from fecha) = ? and extract(month from fecha) >= ?", @agno_inicio, @mes_antes_inicio)
      #Consulta 2
      @model_ventas2 = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id").select("products.nombre, sum(details.precio * details.cantidad) as valor").group("products.nombre")
      @ventas2 = @model_ventas2.where("extract(year from fecha) = ? and extract(month from fecha) <= ?", @agno_fin, @mes_antes_fin)
      @ventas1.each do |ventas1|
        @ventas2.each do |ventas2|
          if(ventas1.nombre == ventas2.nombre)
            ventas1.valor = ventas1.valor + ventas2.valor
            ventas2.nombre = ''
          end
        end
      end
      @ventas = @ventas1 + @ventas2
      #Calculos por meses seleccionados (Ej: Enero - Marzo (2016))
      #C1
      @model11 = Trip.joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("trips.salida as salida, products.nombre as nombre, providers.nombre as nombre_proveedor, summaries.cantidad as cantidad, (summaries.precio * summaries.cantidad) as valor_invertido, trips.ship_id as embarcaciones_id,  costs.alimentacion, costs.combustible, costs.personal, costs.emergencia, ships.nombre as nombre_embarcacion").order("salida ASC")
      @boats31 = @model11.where("extract(year from salida) = ? and extract(month from salida) >= ?", @agno_inicio, @mes_antes_inicio)
      @model_ventas11 = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id join clients on clients.id = sales.client_id").select("sales.fecha as fecha, products.nombre as nombre, clients.nombre as cliente_nombre, details.precio as valor_venta, details.cantidad as cantidad").order("fecha ASC")
      @ventas31 = @model_ventas11.where("extract(year from fecha) = ? and extract(month from fecha) >= ?", @agno_inicio, @mes_antes_inicio)
      #C2
      @model12 = Trip.joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("trips.salida as salida, products.nombre as nombre, providers.nombre as nombre_proveedor, summaries.cantidad as cantidad, (summaries.precio * summaries.cantidad) as valor_invertido, trips.ship_id as embarcaciones_id,  costs.alimentacion, costs.combustible, costs.personal, costs.emergencia, ships.nombre as nombre_embarcacion").order("salida ASC")
      @boats32 = @model12.where("extract(year from salida) = ? and extract(month from salida) <= ?", @agno_fin, @mes_antes_fin)
      @model_ventas12 = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id join clients on clients.id = sales.client_id").select("sales.fecha as fecha, products.nombre as nombre, clients.nombre as cliente_nombre, details.precio as valor_venta, details.cantidad as cantidad").order("fecha ASC")
      @ventas32 = @model_ventas12.where("extract(year from fecha) <= ? and extract(month from fecha) <= ?", @agno_fin, @mes_antes_fin)
      #C1 + C2
      @boats3 = @boats31 + @boats32
      @ventas3 = @ventas31 + @ventas32
      #Consulta para grafico mas vendido
      @model111 = Trip.where("extract(year from salida) = ? and extract(month from salida) >= ?", @agno_inicio, @mes_antes_inicio).joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").group("products.nombre").sum("(summaries.precio * summaries.cantidad) + costs.alimentacion + costs.combustible + costs.personal + costs.emergencia")
      @model112 = Trip.where("extract(year from salida) = ? and extract(month from salida) <= ?", @agno_fin, @mes_antes_fin).joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").group("products.nombre").sum("(summaries.precio * summaries.cantidad) + costs.alimentacion + costs.combustible + costs.personal + costs.emergencia")
      @model1 = Array.new()
      aux_da1 = 0
      entro_ads1 = true
      @model111.each do |model111|
        @model112.each do |model112|
          if(model111.first == model112.first)
            cont = (model111.second + model112.second)
            #model112.products_nombre = ''
            @model1[aux_da1] = [model111.first.to_s, cont]
            aux_da1 = aux_da1 + 1
            entro_ads1 = false
          end
        end
        if(entro_ads1 == true)
          @model1[aux_da1] = [model111.first.to_s, model111.second.to_i]
          aux_da1 = aux_da1 + 1
        end
        entro_ads1 = true
      end
      entro_ads2 = true
      @model112.each do |model112|
        @model111.each do |model111|
          if(model111.first == model112.first)
            entro_ads2 = false
          end
        end
        if(entro_ads2 == true)
          @model1[aux_da1] = [model112.first.to_s, model112.second.to_i]
          aux_da1 = aux_da1 + 1
        end
        entro_ads1 = true      
      end
      aux_md1 = 0
      @entro_md1 = false
      @model1.each do |model|
        aux_md1 = aux_md1 + 1
      end
      if(aux_md1 > 0)
        @entro_md1 = true
      else
        @xd = {"None" => 100}
      end

      #Consulta para grafico de mes con mas ganancia
      #C1
      @model21 = Sale.order("to_char(fecha,'Mon-YY') DESC").where("extract(year from fecha) = ? and extract(month from fecha) >= ?", @agno_inicio, @mes_antes_inicio).joins("join details on details.sale_id = sales.id").group("to_char(fecha,'Mon-YY')").sum("(details.cantidad * details.precio)")
      #C2
      @model22 = Sale.order("to_char(fecha,'Mon-YY') DESC").where("extract(year from fecha) = ? and extract(month from fecha) <= ?", @agno_fin, @mes_antes_fin).joins("join details on details.sale_id = sales.id").group("to_char(fecha,'Mon-YY')").sum("(details.cantidad * details.precio)")
      #C1+C2
      @model2 = Array.new()
      count_ads3 = 0
      @model21.each do |model21|
        @model2[count_ads3] [model21.to_char_fecha_mon_yy, model21.sum_details_cantidad_all_details_precio.to_i]
        count_ads3 = count_ads3 + 1
      end
      @model22.each do |model22|
        @model2[count_ads3] [model22.to_char_fecha_mon_yy, model22.sum_details_cantidad_all_details_precio.to_i]
        count_ads3 = count_ads3 + 1
      end
      #@model2 = @model21
      aux_md2 = 0
      @entro_md2 = false
      @model2.each do |model|
        aux_md2 = aux_md2 + 1
      end
      if(aux_md2 > 0)
        @entro_md2 = true
      else
        @xd2 = {"None" => 100}
      end
      #@model3 = Venta.group("to_char(fecha,'Mon-YY')").sum("(ventas.cantidad * ventas.valor)")
      @meses_agno = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
      #Calculo de meses seleccionados
      @count_meses = (@agno_f * 12 + @mes_fin) - (@agno_i* 12 + @mes_inicio)
      @count_m = @count_meses.to_i
      @meses_agno = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre','Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
      #Gastos por meses
      @count = 0
      @gastos = Array.new(24, 0)
      agno_anterior = @agno_i
      @boats3.each do |gastos|
        fecha = gastos.salida.to_s
        fecha_split = fecha.split('-')
        mes = fecha_split.second.to_i
        agno = fecha_split.first.to_i
        if(agno_anterior != agno)
          mes = mes + 12
        end
        @gastos[mes-1] += (gastos.valor_invertido + gastos.alimentacion + gastos.combustible + gastos.personal + gastos.emergencia)
      end
      #Ganacia por meses
      @count = 0
      @ganancia = Array.new(24, 0)
      agno_anterior = @agno_i
      entro1 = false
      @ventas3.each do |gan|
        entro1 = true
        fecha = gan.fecha.to_s
        fecha_split = fecha.split('-')
        mes = fecha_split.second.to_i
        agno = fecha_split.first.to_i
        if(agno_anterior != agno)
          mes = mes + 12
        end
        @ganancia[mes-1] += gan.valor_venta * gan.cantidad
      end
      if(entro1 == false)
        for i in 0..23
          @ganancia[i] = 0
        end
      end
    end
  end
  def reporteY_pdf
    #Sacar variables de fechas del fomr
    @fecha_inicio = params[:inicio].to_s
    @fecha_fin = params[:fin].to_s
    #Mes y año para fecha inicio
    @fecha_split_inicio = @fecha_inicio.split('-')
    @mes_antes_inicio = @fecha_split_inicio.first
    @mes_inicio = @fecha_split_inicio.first.to_i
    @agno_inicio = @fecha_split_inicio.second.to_i.to_s
    @agno_i = @fecha_split_inicio.second.to_i
    #Mes y año para fecha fin
    @fecha_split_fin = @fecha_fin.split('-')
    @mes_antes_fin = @fecha_split_fin.first
    @mes_fin = @fecha_split_fin.first.to_i
    @agno_fin = @fecha_split_fin.second.to_i.to_s
    @agno_f = @fecha_split_fin.second.to_i
    if (@agno_inicio > @agno_fin)
       redirect_to :action => "index", :notice => "¡Error! La selección de rango de fechas no es válida." 
      #redirect_to(show_path, {:flash => { :error => "Insufficient rights!" }})
    else
      if(@agno_inicio == @agno_fin)
        if(@mes_inicio > @mes_fin)          
          redirect_to :action => "index", :notice => "¡Error! La selección de rango de fechas no es válida." 
        end
      end
      aux = @agno_f - @agno_i
      if(aux > 1)
        redirect_to :action => "index", :notice => "¡Error! La selección de rango debe ser máximo hasta 2 años." 
      end
    end
    #Consulta BD para calculo por productos entre fechas seleccionadas
    if(@agno_inicio == @agno_fin)
      @resumen = Trip.joins("join costs on costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("products.nombre, sum(costs.alimentacion + costs.combustible + costs.personal + costs.emergencia) as inversion, SUM(summaries.cantidad) as cantidad, SUM(summaries.precio*summaries.cantidad) as precio").group("products.nombre")
      @boats = @resumen.where("(extract(year from salida) >= ? AND extract(month from salida) >= ?) AND (extract(year from salida) <= ? AND extract(month from salida) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin)
      @model_ventas = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id").select("products.nombre, sum(details.precio * details.cantidad) as valor").group("products.nombre")
      @ventas = @model_ventas.where("(extract(year from fecha) >= ? and extract(month from fecha) >= ?) AND (extract(year from fecha) <= ? and extract(month from fecha) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin)
      #Calculos por meses seleccionados (Ej: Enero - Marzo (2016))
      @model1 = Trip.joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("trips.salida as salida, products.nombre as nombre, providers.nombre as nombre_proveedor, summaries.cantidad as cantidad, (summaries.precio * summaries.cantidad) as valor_invertido, trips.ship_id as embarcaciones_id,  costs.alimentacion, costs.combustible, costs.personal, costs.emergencia, ships.nombre as nombre_embarcacion").order("salida ASC")
      @boats3 = @model1.where("(extract(year from salida) >= ? and extract(month from salida) >= ?) AND (extract(year from salida) <= ? and extract(month from salida) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin)
      @model_ventas1 = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id join clients on clients.id = sales.client_id").select("sales.fecha as fecha, products.nombre as nombre, clients.nombre as cliente_nombre, details.precio as valor_venta, details.cantidad as cantidad").order("fecha ASC")
      @ventas3 = @model_ventas1.where("(extract(year from fecha) >= ? and extract(month from fecha) >= ?) AND (extract(year from fecha) <= ? and extract(month from fecha) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin)
      #Consulta para grafico mas vendido
      @model1 = Trip.where("(extract(year from salida) >= ? and extract(month from salida) >= ?) AND (extract(year from salida) <= ? and extract(month from salida) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin).joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").group("products.nombre").sum("(summaries.precio * summaries.cantidad) + costs.alimentacion + costs.combustible + costs.personal + costs.emergencia")
      aux_md1 = 0
      @entro_md1 = false
      @model1.each do |model|
        aux_md1 = aux_md1 + 1
      end
      if(aux_md1 > 0)
        @entro_md1 = true
      else
        @xd = {"None" => 100}
      end

      #Consulta para grafico de mes con mas ganancia
      @model2 = Sale.order("to_char(fecha,'Mon-YY') DESC").where("(extract(year from fecha) >= ? and extract(month from fecha) >= ?) AND (extract(year from fecha) <= ? and extract(month from fecha) <= ?)", @agno_inicio, @mes_antes_inicio, @agno_fin, @mes_antes_fin).joins("join details on details.sale_id = sales.id").group("to_char(fecha,'Mon-YY')").sum("(details.cantidad * details.precio)")
      aux_md2 = 0
      @entro_md2 = false
      @model2.each do |model|
        aux_md2 = aux_md2 + 1
      end
      if(aux_md2 > 0)
        @entro_md2 = true
      else
        @xd2 = {"None" => 100}
      end
      #@model3 = Venta.group("to_char(fecha,'Mon-YY')").sum("(ventas.cantidad * ventas.valor)")
      @meses_agno = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
      #Calculo de meses seleccionados
      @count_meses = (@agno_f * 12 + @mes_fin) - (@agno_i* 12 + @mes_inicio)
      @count_m = @count_meses.to_i
      @meses_agno = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre','Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
      #Gastos por meses
      @count = 0
      @gastos = Array.new(24, 0)
      agno_anterior = @agno_i
      @boats3.each do |gastos|
        fecha = gastos.salida.to_s
        fecha_split = fecha.split('-')
        mes = fecha_split.second.to_i
        agno = fecha_split.first.to_i
        if(agno_anterior != agno)
          mes = mes + 12
        end
        @gastos[mes-1] += (gastos.valor_invertido + gastos.alimentacion + gastos.combustible + gastos.personal + gastos.emergencia)
      end
      #Ganacia por meses
      @count = 0
      @ganancia = Array.new(24, 0)
      agno_anterior = @agno_i
      entro1 = false
      @ventas3.each do |gan|
        entro1 = true
        fecha = gan.fecha.to_s
        fecha_split = fecha.split('-')
        mes = fecha_split.second.to_i
        agno = fecha_split.first.to_i
        if(agno_anterior != agno)
          mes = mes + 12
        end
        @ganancia[mes-1] += gan.valor_venta * gan.cantidad
      end
      if(entro1 == false)
        for i in 0..23
          @ganancia[i] = 0
        end
      end
    else
      #Consulta 1
      @resumen1 = Trip.joins("join costs on costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("products.nombre, sum(costs.alimentacion + costs.combustible + costs.personal + costs.emergencia) as inversion, SUM(summaries.cantidad) as cantidad, SUM(summaries.precio*summaries.cantidad) as precio").group("products.nombre")
      @boats1 = @resumen1.where("extract(year from salida) = ? AND extract(month from salida) >= ?", @agno_inicio, @mes_antes_inicio)
      #Consulta 2
      @resumen2 = Trip.joins("join costs on costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("products.nombre, sum(costs.alimentacion + costs.combustible + costs.personal + costs.emergencia) as inversion, SUM(summaries.cantidad) as cantidad, SUM(summaries.precio*summaries.cantidad) as precio").group("products.nombre")
      @boats2 = @resumen2.where("extract(year from salida) = ? AND extract(month from salida) <= ?", @agno_fin, @mes_antes_fin)
      @boats1.each do |boats1|
        @boats2.each do |boats2|
          if(boats1.nombre == boats2.nombre)
            boats1.inversion = boats1.inversion + boats2.inversion
            boats1.cantidad = boats1.cantidad + boats2.cantidad
            boats1.precio = boats1.precio + boats2.precio
            boats2.nombre = ''
            boats2.inversion = nil
            boats2.cantidad = nil
            boats2.precio = nil
          end
        end
      end
      @boats = @boats1 + @boats2
      #Consulta 1
      @model_ventas1 = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id").select("products.nombre, sum(details.precio * details.cantidad) as valor").group("products.nombre")
      @ventas1 = @model_ventas1.where("extract(year from fecha) = ? and extract(month from fecha) >= ?", @agno_inicio, @mes_antes_inicio)
      #Consulta 2
      @model_ventas2 = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id").select("products.nombre, sum(details.precio * details.cantidad) as valor").group("products.nombre")
      @ventas2 = @model_ventas2.where("extract(year from fecha) = ? and extract(month from fecha) <= ?", @agno_fin, @mes_antes_fin)
      @ventas1.each do |ventas1|
        @ventas2.each do |ventas2|
          if(ventas1.nombre == ventas2.nombre)
            ventas1.valor = ventas1.valor + ventas2.valor
            ventas2.nombre = ''
          end
        end
      end
      @ventas = @ventas1 + @ventas2
      #Calculos por meses seleccionados (Ej: Enero - Marzo (2016))
      #C1
      @model11 = Trip.joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("trips.salida as salida, products.nombre as nombre, providers.nombre as nombre_proveedor, summaries.cantidad as cantidad, (summaries.precio * summaries.cantidad) as valor_invertido, trips.ship_id as embarcaciones_id,  costs.alimentacion, costs.combustible, costs.personal, costs.emergencia, ships.nombre as nombre_embarcacion").order("salida ASC")
      @boats31 = @model11.where("extract(year from salida) = ? and extract(month from salida) >= ?", @agno_inicio, @mes_antes_inicio)
      @model_ventas11 = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id join clients on clients.id = sales.client_id").select("sales.fecha as fecha, products.nombre as nombre, clients.nombre as cliente_nombre, details.precio as valor_venta, details.cantidad as cantidad").order("fecha ASC")
      @ventas31 = @model_ventas11.where("extract(year from fecha) = ? and extract(month from fecha) >= ?", @agno_inicio, @mes_antes_inicio)
      #C2
      @model12 = Trip.joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").select("trips.salida as salida, products.nombre as nombre, providers.nombre as nombre_proveedor, summaries.cantidad as cantidad, (summaries.precio * summaries.cantidad) as valor_invertido, trips.ship_id as embarcaciones_id,  costs.alimentacion, costs.combustible, costs.personal, costs.emergencia, ships.nombre as nombre_embarcacion").order("salida ASC")
      @boats32 = @model12.where("extract(year from salida) = ? and extract(month from salida) <= ?", @agno_fin, @mes_antes_fin)
      @model_ventas12 = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id join clients on clients.id = sales.client_id").select("sales.fecha as fecha, products.nombre as nombre, clients.nombre as cliente_nombre, details.precio as valor_venta, details.cantidad as cantidad").order("fecha ASC")
      @ventas32 = @model_ventas12.where("extract(year from fecha) <= ? and extract(month from fecha) <= ?", @agno_fin, @mes_antes_fin)
      #C1 + C2
      @boats3 = @boats31 + @boats32
      @ventas3 = @ventas31 + @ventas32
      #Consulta para grafico mas vendido
      @model111 = Trip.where("extract(year from salida) = ? and extract(month from salida) >= ?", @agno_inicio, @mes_antes_inicio).joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").group("products.nombre").sum("(summaries.precio * summaries.cantidad) + costs.alimentacion + costs.combustible + costs.personal + costs.emergencia")
      @model112 = Trip.where("extract(year from salida) = ? and extract(month from salida) <= ?", @agno_fin, @mes_antes_fin).joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on summaries.product_id = products.id").group("products.nombre").sum("(summaries.precio * summaries.cantidad) + costs.alimentacion + costs.combustible + costs.personal + costs.emergencia")
      @model1 = Array.new()
      aux_da1 = 0
      entro_ads1 = true
      @model111.each do |model111|
        @model112.each do |model112|
          if(model111.first == model112.first)
            cont = (model111.second + model112.second)
            #model112.products_nombre = ''
            @model1[aux_da1] = [model111.first.to_s, cont]
            aux_da1 = aux_da1 + 1
            entro_ads1 = false
          end
        end
        if(entro_ads1 == true)
          @model1[aux_da1] = [model111.first.to_s, model111.second.to_i]
          aux_da1 = aux_da1 + 1
        end
        entro_ads1 = true
      end
      entro_ads2 = true
      @model112.each do |model112|
        @model111.each do |model111|
          if(model111.first == model112.first)
            entro_ads2 = false
          end
        end
        if(entro_ads2 == true)
          @model1[aux_da1] = [model112.first.to_s, model112.second.to_i]
          aux_da1 = aux_da1 + 1
        end
        entro_ads1 = true      
      end
      aux_md1 = 0
      @entro_md1 = false
      @model1.each do |model|
        aux_md1 = aux_md1 + 1
      end
      if(aux_md1 > 0)
        @entro_md1 = true
      else
        @xd = {"None" => 100}
      end

      #Consulta para grafico de mes con mas ganancia
      #C1
      @model21 = Sale.order("to_char(fecha,'Mon-YY') DESC").where("extract(year from fecha) = ? and extract(month from fecha) >= ?", @agno_inicio, @mes_antes_inicio).joins("join details on details.sale_id = sales.id").group("to_char(fecha,'Mon-YY')").sum("(details.cantidad * details.precio)")
      #C2
      @model22 = Sale.order("to_char(fecha,'Mon-YY') DESC").where("extract(year from fecha) = ? and extract(month from fecha) <= ?", @agno_fin, @mes_antes_fin).joins("join details on details.sale_id = sales.id").group("to_char(fecha,'Mon-YY')").sum("(details.cantidad * details.precio)")
      #C1+C2
      @model2 = Array.new()
      count_ads3 = 0
      @model21.each do |model21|
        @model2[count_ads3] [model21.to_char_fecha_mon_yy, model21.sum_details_cantidad_all_details_precio.to_i]
        count_ads3 = count_ads3 + 1
      end
      @model22.each do |model22|
        @model2[count_ads3] [model22.to_char_fecha_mon_yy, model22.sum_details_cantidad_all_details_precio.to_i]
        count_ads3 = count_ads3 + 1
      end
      #@model2 = @model21
      aux_md2 = 0
      @entro_md2 = false
      @model2.each do |model|
        aux_md2 = aux_md2 + 1
      end
      if(aux_md2 > 0)
        @entro_md2 = true
      else
        @xd2 = {"None" => 100}
      end
      #@model3 = Venta.group("to_char(fecha,'Mon-YY')").sum("(ventas.cantidad * ventas.valor)")
      @meses_agno = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
      #Calculo de meses seleccionados
      @count_meses = (@agno_f * 12 + @mes_fin) - (@agno_i* 12 + @mes_inicio)
      @count_m = @count_meses.to_i
      @meses_agno = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre','Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
      #Gastos por meses
      @count = 0
      @gastos = Array.new(24, 0)
      agno_anterior = @agno_i
      @boats3.each do |gastos|
        fecha = gastos.salida.to_s
        fecha_split = fecha.split('-')
        mes = fecha_split.second.to_i
        agno = fecha_split.first.to_i
        if(agno_anterior != agno)
          mes = mes + 12
        end
        @gastos[mes-1] += (gastos.valor_invertido + gastos.alimentacion + gastos.combustible + gastos.personal + gastos.emergencia)
      end
      #Ganacia por meses
      @count = 0
      @ganancia = Array.new(24, 0)
      agno_anterior = @agno_i
      entro1 = false
      @ventas3.each do |gan|
        entro1 = true
        fecha = gan.fecha.to_s
        fecha_split = fecha.split('-')
        mes = fecha_split.second.to_i
        agno = fecha_split.first.to_i
        if(agno_anterior != agno)
          mes = mes + 12
        end
        @ganancia[mes-1] += gan.valor_venta * gan.cantidad
      end
      if(entro1 == false)
        for i in 0..23
          @ganancia[i] = 0
        end
      end
    end
    respond_to do |format|
      format.pdf do
        render pdf: "file_name_of_your_choice",
               template: "calculos/reporteY.pdf.erb",
               encoding: 'UTF-8',
               :javascript_delay=>5000               
      end
    end
  end
  def pdf
     @fecha = params[:field1].to_s
    @fecha_split = @fecha.split('-')
    @mes_antes = @fecha_split.first
    @mes = @fecha_split.first.to_i
    @agno = @fecha_split.second.to_i.to_s
    @meses_agno = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre']
    @mes_salida = @meses_agno[(@mes-1)]
    @model = Trip.joins("join costs ON costs.trip_id = trips.id join purchases on purchases.id = trips.purchase_id join providers on providers.id = purchases.provider_id join ships on ships.id = trips.ship_id join summaries on summaries.purchase_id = purchases.id join products on products.id = summaries.product_id").select("products.nombre as nombre_producto, providers.nombre as nombre_proveedor, trips.salida as fechasalida, costs.alimentacion as alimentacion, costs.combustible as combustible, costs.personal as personal, costs.emergencia as emergencia, ships.nombre as nombre_embarcacion, summaries.cantidad as cantidad, summaries.precio as precio, summaries.cantidad as cantidad")
    @boats = @model.where("extract(year from salida) = ? and extract(month from salida) = ?", @agno, @mes_antes)
    @model_ventas = Sale.joins("join details on details.sale_id = sales.id join products on products.id = details.product_id join clients on clients.id = sales.client_id").select("*")
    @ventas = @model_ventas.where("extract(year from fecha) = ? and extract(month from fecha) = ?", @agno, @mes_antes)
    respond_to do |format|
      format.pdf do
        render pdf: "file_name_of_your_choice",
               template: "calculos/ejemplo.pdf.erb",
               encoding: 'UTF-8'              
      end
    end
  end
  def pdf_agno
    @fecha = params[:field1].to_s
    

    @model = Itinerario.joins("join costos ON costos.itinerario_id = itinerarios.id join compras on compras.id = itinerarios.compra_id join proveedores on proveedores.id = compras.proveedor_id join embarcaciones on embarcaciones.id = itinerarios.embarcacion_id join productos on compras.producto_id = productos.id").select("itinerarios.fechasalida as fecha_salida, productos.nombre as nombre, proveedores.nombre as nombre_proveedor, proveedores.apaterno as apellido_paterno, proveedores.amaterno as apellido_materno, compras.cantidad as cantidad, compras.precio as valor_invertido, fechasalida, embarcacion_id,  costos.alimentacion, costos.combustible, costos.personal, costos.emergencia, embarcaciones.nombre as nombre_embarcacion")
    @boats = @model.where("extract(year from fechasalida) = ?", @fecha)

    @model_ventas = Venta.joins("join productos on productos.id = ventas.producto_id join clientes on clientes.id = ventas.cliente_id").select("ventas.fecha as fecha, productos.nombre as nombre, clientes.empresa as cliente_nombre, ventas.valor as valor_venta, ventas.cantidad as cantidad")
    @ventas = @model_ventas.where("extract(year from fecha) = ?", @fecha)
    
    url = ActionController::Base.helpers.asset_path('image2.png')
    ola = '
      <html>
        <head>
          <title></title>
          <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> 
        </head>
        <style type="text/css">
          th, td {
            padding: 15px;
              text-align: center;
              border-bottom: 1px solid #ddd;
          } 
        </style>
        <body>
          <img src="http://i65.tinypic.com/14kh8a8.png" >
          <h2><strong>Reporte del año '+@fecha+'</strong></h2>

          <h2>Costos de Inversión</h2>
          <table>
            <thead>
                  <th>Nombre Producto</th>
                  <th>Proveedor</th>
                  <th>Fecha</th>
                  <th>Cantidad</th>
                  <th>Valor invertido</th>
                  <th>Nombre de embarcación</th>
                  <th>Costos de Transporte</th>
                </thead>
                <tbody>'
          aux_valor_invertido = 0
          aux_costos_x = 0
          salida = '';
          @boats.each do |boat|
            nombre_proveedor = boat.nombre_proveedor + " " + boat.apellido_paterno
            aux_valor_invertido = (aux_valor_invertido + boat.valor_invertido)
            costos_x = boat.alimentacion + boat.combustible + boat.personal + boat.emergencia
            aux_costos_x = (aux_costos_x + costos_x)
            num1 = number_with_delimiter(boat.valor_invertido, delimiter: ".")
            num2 = number_with_delimiter(costos_x, delimiter: ".")
            salida = salida + '<tr><td>'+boat.nombre+'</td><td>'+nombre_proveedor+'</td><td>'+boat.fecha_salida.to_s+'</td><td>'+boat.cantidad.to_s+' Kg</td><td>$'+num1.to_s+'</td><td>'+boat.nombre_embarcacion+'</td><td>$'+num2.to_s+'</td></tr>'
          end
          num3 = number_with_delimiter(aux_valor_invertido, delimiter: ".")
          num4 = number_with_delimiter(aux_costos_x, delimiter: ".")
          salida = salida + '<tr><td>TOTAL</td><td></td><td></td><td></td><td>$'+num3.to_s+'</td><td></td><td>$'+num4.to_s+'</td></tr>'
          ola = ola + salida   
          ola = ola +      '</tbody>
          </table>
          </br>
          <h2>Ganancia de Venta de Productos</h2>
          <table>
            <thead>
              <th>Nombre Producto</th>
              <th>Cliente</th>
              <th>Fecha</th>
              <th>Valor Venta</th>
              <th>Cantidad</th>
              <th>Venta Total</th>
            </thead>
            <tbody>'
          aux_total = 0
          salida = '';
          @ventas.each do |venta|
            num1 = number_with_delimiter(venta.valor_venta, delimiter: ".")
            total = venta.valor_venta * venta.cantidad
            aux_total = aux_total + total
            num2 = number_with_delimiter(total, delimiter: ".")
            salida = salida + '<tr><td>'+venta.nombre+'</td><td>'+venta.cliente_nombre+'</td><td>'+venta.fecha.to_s+'</td><td>$'+num1.to_s+'</td><td>'+venta.cantidad.to_s+' Kg</td><td>$'+num2.to_s+'</td></tr>'
          end
          num3 = number_with_delimiter(aux_total, delimiter: ".")
          salida = salida + '<tr><td>TOTAL</td><td></td><td></td><td></td><td></td><td>$'+num3.to_s+'</td></tr>'
          ola = ola + salida
          num1 = number_with_delimiter(aux_valor_invertido, delimiter: ".")
          num2 = number_with_delimiter(aux_costos_x, delimiter: ".")
          num3 = number_with_delimiter(aux_total, delimiter: ".")
          num4 = number_to_currency(aux_total- (aux_valor_invertido + aux_costos_x), delimiter: ".", precision: 0)
          num5 = number_with_delimiter((aux_valor_invertido + aux_costos_x), delimiter: ".")
          ola = ola +  '</tbody>
          </table>
          </br>
          <h3>Resumen</h3>
          <table class="table">
            <thead>
              <tr>
                <th>Costos</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Inversión</td>
                <td>$'+num1.to_s+'</td>
              </tr>
              <tr>
                <td>Transporte</td>
                <td>$'+num2.to_s+'</td>
              </tr>
              <tr>
                <td>TOTAL</td>
                <td>$'+num5.to_s+'</td>
              </tr>
            </tbody>
          </table>
          <table class="table">
            <thead>
              <tr>
                <th>Ganancia</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Venta Productos</td>
                <td>$'+num3.to_s+'</td>
              </tr>
            </tbody>
          </table>
          <table class="table">
            <thead>
              <tr>
                <th>Ganancia Total</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Ganacias - Costos</td>
                <td>'+num4.to_s+'</td>
              </tr>
            </tbody>
          </table>
        </body>
      </html>
    '
    nombre = "reporte "+@fecha+".pdf"
    pdf = WickedPdf.new.pdf_from_string(ola)
      send_data(pdf, 
        :filename => nombre, 
        :disposition => 'attachment') 
  end
  def show
    @boats = Itinerario.joins("INNER JOIN compras ON itinerarios.compra_id = compras.id INNER JOIN productos ON compras.producto_id = productos.id INNER JOIN costos ON itinerarios.id = costos.itinerario_id").group("productos.nombre").select("productos.nombre as nombre, SUM(compras.precio) as inversion, SUM(costos.alimentacion + costos.combustible + costos.personal + costos.emergencia) as valor_invertido")
    @sales = Venta.joins("INNER JOIN productos ON ventas.producto_id = productos.id").group("productos.nombre").select("nombre, sum(valor*cantidad) AS valor")
    @num = Venta.joins("INNER JOIN productos ON ventas.producto_id = productos.id").group(:nombre).count
      ola = '
      <style>
table, td, th {    
    border: 1px solid #ddd;
    text-align: left;
}

table {
    border-collapse: collapse;
    width: 100%;
}

th, td {
    padding: 15px;
}
</style>
      
      <table class="mdl-data-table mdl-js-data-table page">
      <thead>
        <tr>
          <th>Nombre Producto</th>
          <th>Costos de Compra</th>
          <th>Costos de Embarcacion</th>
          <th>Suma de Costos</th>
          <th>Total Vendido</th>
          <th>Ganancia</th>

        </tr>
      </thead>

    <tbody>'
      @boats.each do |boat|
        ola = ola + '<tr>
          <td class="mdl-data-table__cell--non-numeric">'+boat.nombre+'</td>
          <td class="mdl-data-table__cell--numeric">'+boat.inversion.to_s+'</td>
          <td class="mdl-data-table__cell--numeric">'+boat.valor_invertido.to_s+'</td>
          <td class="mdl-data-table__cell--numeric">'+(boat.inversion+boat.valor_invertido).to_s+'</td>'
          @sales.each do |sales|
            if sales.nombre == boat.nombre
              ola = ola + '<td class="mdl-data-table__cell--numeric">'+sales.valor.to_s+'</td>
              <td class="mdl-data-table__cell--numeric">'+((sales.valor) - (boat.inversion+boat.valor_invertido)).to_s+'</td>'
            
            end

          end
          if(@num == {})
            ola = ola+ '<td class="mdl-data-table__cell--numeric">0</td>
            <td class="mdl-data-table__cell--numeric">0</td>'
          end
          
        ola = ola + '</tr>'
      end
    ola = ola +'</tbody>
    </table>'

      pdf = WickedPdf.new.pdf_from_string(ola)
      send_data(pdf, 
        :filename => "Calculo.pdf", 
        :disposition => 'attachment') 
      
    
  end
  def boats_pdf
      barcos = Boat.all
      ola2 = '
      <style>

        table, td, th {    
            border: 1px solid #ddd;
            text-align: left;
        }

        table {
            border-collapse: collapse;
            width: 100%;
        }

        th, td {
            padding: 15px;
        }
        </style>
        <table class="mdl-data-table mdl-js-data-table page">
        <thead>
          <tr>
            <th class="mdl-data-table__cell--non-numeric">Nombre de embarcación</th>
            <th>Patente</th>
            <th>Metros</th>
          </tr>
        </thead>

      <tbody>'
        barcos.each do |boat|
          ola2 = ola2 + '<tr>
            <td class="mdl-data-table__cell--non-numeric">'+boat.nombre+'</td>
            <td class="mdl-data-table__cell--numeric">'+boat.patente+'</td>
            <td class="mdl-data-table__cell--numeric">'+boat.metros.to_s+'</td>'          
            
          ola2 = ola2 + '</tr>'
          ola2 = ola2 +'</tbody>
           </table>'
        end
        pdf = WickedPdf.new.pdf_from_string(ola2)
        send_data(pdf, 
          :filename => "Boats.pdf", 
          :disposition => 'attachment')
  end

  # GET /boats/1
  # GET /boats/1.json
  

  private
    # Use callbacks to share common setup or constraints between actions.
    
    def calculo_params
      params.require(:calculo).permit(:nombre, :inversion, :valor_invertido, :valor)
    end
end