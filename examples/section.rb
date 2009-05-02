require 'mrtoolkit'

class SectionMap < MapBase
  def declare
    # declare log fields
    field :ip
    field :client_id
    field :user_id
    field :dt_tm
    field :request
    field :status
    field :result_size
    field :referrer
    field :ua

    emit :section
    emit :count
  end
  def process(input, output)
    if input.request =~ /\/(\w*)\//
      output.section = $1
      output.count = 1
    end
    output
  end
end

class MainJob < JobBase
  def stage1
    mapper SectionMap
    reducer UniqueSumReduce, 1
    indir "logs"
    outdir "section"
  end
end


MainJob.run_command(__FILE__)