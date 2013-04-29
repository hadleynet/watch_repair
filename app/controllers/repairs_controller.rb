class RepairsController < ApplicationController

  before_filter :patch_dates
  
  def patch_dates
    if params[:repair]
      if params[:repair][:received] && params[:repair][:received].length > 0
        params[:repair][:received] = Date.strptime(params[:repair][:received], '%m/%d/%Y').to_s
      end
      if params[:repair][:returned] && params[:repair][:returned].length > 0
        params[:repair][:returned] = Date.strptime(params[:repair][:returned], '%m/%d/%Y').to_s
      end
    elsif params[:field_id] == 'received' || params[:field_id] == 'returned'
      begin
        params[:search_text] = Date.strptime(params[:search_text], '%m/%d/%Y').to_s
      rescue Exception=>e
        # swallow the conversion and just treat it as a simple text search
      end
    end
  end

  # GET /repairs
  # GET /repairs.json
  def index
    if params[:field_id] && params[:search_text]
      @search_field = params[:field_id]
      @search_text = params[:search_text]
      if params[:field_id] == 'store'
        stores = Store.where(Store.arel_table['name'].matches("%#{@search_text}%"))
        store_ids = stores.collect{|store| store.id}
        @repairs = Repair.where(:store_id => store_ids).order('received DESC')
        @repair_count = @repairs.length
      else
        repair_fields = Repair.arel_table
        @search_field = params[:field_id]
        @search_text = params[:search_text]
        @repairs = Repair.where(repair_fields[@search_field].matches("%#{@search_text}%")).order('received DESC')
        @repair_count = @repairs.length
      end
    else
      @repairs = Repair.order('received DESC')
    end
    
    @repairs = @repairs.page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @repairs }
    end
  end

  # GET /repairs/1
  # GET /repairs/1.json
  def show
    @repair = Repair.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @repair }
    end
  end

  # GET /repairs/new
  # GET /repairs/new.json
  def new
    @repair = Repair.new
    @repair.received = Date.today
    @stores = Store.ordered_by_name
    latest_repair = Repair.last
    if latest_repair
      @last_store_id = latest_repair.store_id
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @repair }
    end
  end

  # GET /repairs/1/edit
  def edit
    @repair = Repair.find(params[:id])
    @stores = Store.ordered_by_name
  end

  # POST /repairs
  # POST /repairs.json
  def create
    @repair = Repair.new(params[:repair])

    respond_to do |format|
      if @repair.save
        format.html { redirect_to @repair, notice: 'Repair was successfully created.' }
        format.json { render json: @repair, status: :created, location: @repair }
      else
        format.html { render action: "new" }
        format.json { render json: @repair.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /repairs/1
  # PUT /repairs/1.json
  def update
    @repair = Repair.find(params[:id])

    respond_to do |format|
      if @repair.update_attributes(params[:repair])
        if @repair.invoice
          @repair.invoice.update_total_and_save!
        end
        format.html { redirect_to @repair, notice: 'Repair was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @repair.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repairs/1
  # DELETE /repairs/1.json
  def destroy
    @repair = Repair.find(params[:id])
    invoice = @repair.invoice
    @repair.destroy
    if invoice
      invoice.update_total_and_save!
    end
    respond_to do |format|
      format.html { redirect_to repairs_url }
      format.json { head :no_content }
    end
  end
end
