This is a toy project to play with Ruby on Rails.

As a thematic, it implementes a minimal backend application providing a simple vaccine tracking system.

# Scenario

This section document the rough idea that a customer might come with as identified needs.

The solution must permit to list available vaccines for a country and record
fullfilled injections.

It must include support of:
- a basic web backend
- a rake task that allow large import of recorded injections
- a RESTful API

The backend should allow to the following:
1. Create/Read/Delete country, with the following required fields:
  - name: string,
  - reference: string
2. Create/Read/Update/Delete vaccine, with the following required fields.
  - name: string,
  - reference: string,
  - composition: long text,
  - vaccine booster delay in days : integer,
  - mandatory: boolean,
  - countries in which vaccine is available: array of countries

# Implementation specification

The implementation use the following model:

![Overview of the database schema](https://raw.githubusercontent.com/psychoslave/vaccine-tracker/main/db/schema.png)

It allows to make a clear distinction between vaccines as product and vaccines
as inoculation acts, to state in which country a product is available, and
to express for each inoculation who receid it (anonymous user identifier), in
which country it was delivered and which product it pertains to.


# Install

You can run the application locally provided that you alreday have Ruby and
Bundler installed, simply run the following instructions:
```
# Fetch required software component
git clone https://github.com/psychoslave/vaccine-tracker.git
cd vaccine-tracker
bundle install

# Import minimal required data including those for countries and fake vaccine
# items
bin/rails db:setup

# Optional but recommanded to test with fake inoculation records
rake inoculations:gig_cvs
rake inoculations:import_cvs

# Run the server
bin/rails server
```

# Usage

Once the server run, the backend is accessible though the usual Rails server
address, for example http://[::1]:3000/

The API is accessible through `/ask`, and is versionned with a trigram, the only
version available being `for`, so the basic path is `/ask/for`.

The API provide a per country report, optionnaly focused on a specific user, so
the consultation URI for this kind of report is something like:
- http://[::1]:3000/ask/for/inoculations?country=AF
- http://[::1]:3000/ask/for/inoculations?country=AF&user=3390357475

The API also allow to creat new inoculation records, calling something like
`http://[::1]:3000/ask/for/inoculations/new?&user=4467555310&vaccine=S6994479E`,
the country is automatically taken from the previous injection a user had or is
attributed randomly. Ode? Hey, remember this a toy project, so all fantasy is
permited, isn't it? 😜
