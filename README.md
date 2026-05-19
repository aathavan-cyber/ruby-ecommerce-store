# Ruby E-Commerce Store

A fully functional, modern e-commerce application built with Ruby on Rails 7+. This store features dynamic product catalog browsing, a live guest-to-user shopping cart handoff session layout, dynamic validation constraints for both Credit Card and UPI payment gateways, and responsive SCSS view styling.

---

## 🚀 Getting Started

Follow these step-by-step instructions to get a local copy of this project up and running on a brand-new development machine.

### 📋 Prerequisites

Before setting up, make sure your system has the following core components installed:

* **Ruby**: Version 3.0.0 or higher (Recommended to manage via `rvm` or `rbenv`)
* **PostgreSQL**: Relational database engine running locally on your system
* **Node.js & Yarn**: Required if compiling assets through standard node pipelines
* **Git**: Installed and configured for version tracking

---

## 🛠️ Installation & Local Setup

Open your computer's terminal application and run the following command blocks in sequence:

1. Clone the Repository
```bash
git clone [https://github.com/YOUR_USERNAME/ruby-ecommerce-store.git](https://github.com/YOUR_USERNAME/ruby-ecommerce-store.git)
cd ruby-ecommerce-store
2. Install Project Dependencies
Run bundler to install all the framework gems listed in the Gemfile (including Devise for authentication and the pg gem for database management):

Bash

bundle install
3. Setup and Populate the Database
Make sure your PostgreSQL server is active locally, then run this single command. It triggers three automated operations: creating your local databases, applying the structural schema migrations, and executing the db/seeds.rb file to inject mock product catalogs automatically:

Bash

rails db:setup
(Alternatively, if your database already exists but you simply want to wipe it and refill it clean with your mock seed dataset, run: rails db:reset)

4. Fire up the Rails Web Server
Launch your Puma development environment locally:

Bash

rails server
Now, open your favorite web browser and navigate to: http://localhost:3000
