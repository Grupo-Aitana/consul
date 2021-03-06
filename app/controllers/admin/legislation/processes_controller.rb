class Admin::Legislation::ProcessesController < Admin::Legislation::BaseController
  include Translatable
  include ImageAttributes
  include DownloadSettingsHelper

  has_filters %w[active all], only: :index

  load_and_authorize_resource :process, class: "Legislation::Process"

  def index
    @processes = ::Legislation::Process.send(@current_filter).order(start_date: :desc)
                 .page(params[:page])
    respond_to do |format|
      format.html
      format.csv do
        send_data to_csv(process_for_download, Legislation::Process),
                  type: "text/csv",
                  disposition: "attachment",
                  filename: "legislation_processes.csv"
      end
    end
  end

  def create
    if @process.save
      link = legislation_process_path(@process)
      notice = t("admin.legislation.processes.create.notice", link: link)
      redirect_to edit_admin_legislation_process_path(@process), notice: notice
    else
      flash.now[:error] = t("admin.legislation.processes.create.error")
      render :new
    end
  end

  def update
    if @process.update(process_params)
      set_tag_list

      link = legislation_process_path(@process)
      redirect_back(fallback_location: (request.referer || root_path),
                    notice: t("admin.legislation.processes.update.notice", link: link))
    else
      flash.now[:error] = t("admin.legislation.processes.update.error")
      render :edit
    end
  end

  def destroy
    @process.destroy!
    notice = t("admin.legislation.processes.destroy.notice")
    redirect_to admin_legislation_processes_path, notice: notice
  end

  private

    def process_for_download
      ::Legislation::Process.send(@current_filter).order(start_date: :desc)
    end

    def process_params
      params.require(:legislation_process).permit(allowed_params)
    end

    def allowed_params
      [
        :start_date,
        :end_date,
        :debate_start_date,
        :debate_end_date,
        :draft_start_date,
        :draft_end_date,
        :draft_publication_date,
        :allegations_start_date,
        :allegations_end_date,
        :proposals_phase_start_date,
        :proposals_phase_end_date,
        :result_publication_date,
        :debate_phase_enabled,
        :draft_phase_enabled,
        :allegations_phase_enabled,
        :proposals_phase_enabled,
        :draft_publication_enabled,
        :result_publication_enabled,
        :published,
        :custom_list,
        :background_color,
        :font_color,
        translation_params(::Legislation::Process),
        documents_attributes: [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy],
        image_attributes: image_attributes
      ]
    end

    def set_tag_list
      @process.set_tag_list_on(:customs, process_params[:custom_list])
      @process.save!
    end

    def resource
      @process || ::Legislation::Process.find(params[:id])
    end
end
