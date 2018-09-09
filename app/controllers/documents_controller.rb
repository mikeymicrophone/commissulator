class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index
    @documents = if params[:filtered_attribute]
      Document.where params[:filtered_attribute] => params[:filter_value]
    else
      Document.all
    end.page params[:page]
  end

  def show
  end

  def new
    @document = Document.new document_params
  end

  def edit
  end

  def create
    @document = Document.new document_params
    @document.avatar = current_avatar

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document.commission || @document, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_document
      @document = Document.find(params[:id])
    end

    def document_params
      params.require(:document).permit :capture, :name, :role, :deal_id, :avatar_id
    end
end
