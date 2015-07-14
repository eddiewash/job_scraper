class JobsController < ApplicationController
  def index
    @jobs = Job.all
  end

  def garysguide
    @jobs = Job.where origin: "GarysGuide"
  end

  def glassdoor
    @jobs = Job.where origin: "Glassdoor"
  end
end
