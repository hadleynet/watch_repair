class InvoicesController < ApplicationController
  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.order('issued DESC').page params[:page]
    @stores = Store.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/new
  # GET /invoices/new.json
  def new
    @invoice = Invoice.new
    @stores = Store.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invoice }
    end
  end

  # GET /invoices/1/edit
  def edit
    @invoice = Invoice.find(params[:id])
    @stores = Store.all
  end
  
  def daily
    if params[:invoice][:issued] && params[:invoice][:issued].length > 0
      @invoice_date = Date.strptime(params[:invoice][:issued], '%m/%d/%Y')
      params[:invoice][:issued] = @invoice_date.to_s
    else
      @invoice_date = Date.today
    end
    if params[:commit] == 'Create'
      stores = Repair.stores_with_repairs(@invoice_date)
      stores.each do |store|
        invoice = Invoice.new(params[:invoice])
        invoice.store_id = store.id
        invoice.number = (Invoice.maximum(:number) || WatchRepair::Application.config.invoice_start_number) + 1
        invoice.save!
        Repair.unassigned(invoice.store_id, invoice.issued).each do |repair|
          repair.invoice_id = invoice.id
          repair.save!
        end
        invoice.update_total_and_save!
      end
    end
    
    @invoices = Invoice.for_date(@invoice_date)
    if params[:commit] == 'Quicken'
      buffer = StringIO.new
      Qif::Writer.new(buffer, type='Bank', format='mm/dd/yyyy') do |writer|
        @invoices.each do |invoice|
          writer << Qif::Transaction.new(:date => invoice.issued, :amount => invoice.total, :number => "#{invoice.number}", :payee => invoice.store.name)
        end
      end
      buffer.close
      send_data buffer.string, type: 'application/qif', disposition: 'attachment', filename: "Invoices#{@invoice_date.strftime('%Y%m%d')}.qif"
    else # View
      respond_to do |format|
        format.html { render :all_for_date }
        format.json { render json: @invoices }
      end
    end
  end
  
  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(params[:invoice])
    @invoice.number = (Invoice.maximum(:number) || 0) + 1

    respond_to do |format|
      if @invoice.save
        Repair.unassigned(@invoice.store_id, @invoice.issued).each do |repair|
          repair.invoice_id = @invoice.id
          repair.save!
        end
        @invoice.update_total_and_save!
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render json: @invoice, status: :created, location: @invoice }
      else
        format.html { render action: "new" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /invoices/1
  # PUT /invoices/1.json
  def update
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      if @invoice.update_attributes(params[:invoice])
        format.html { redirect_to invoices_url, notice: 'Invoice was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.repairs.each do |repair|
      repair.invoice_id = nil
      repair.save!
    end
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url }
      format.json { head :no_content }
    end
  end
end
