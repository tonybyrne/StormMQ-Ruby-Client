#--
# Copyright (c) 2010, Tony Byrne & StormMQ Ltd.
# All rights reserved.
#
# Please refer to the LICENSE file that accompanies this source
# for terms of use and redistribution.
#++

require 'rake'
require 'spec/rake/spectask'

Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts  = ['--colour','--format progress']
  t.rcov       = true
  t.rcov_opts  = ['--exclude "spec/*,gems/*"']
end

task :default  => :spec
