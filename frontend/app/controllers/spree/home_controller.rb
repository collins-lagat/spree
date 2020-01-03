module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @bestsellers_products = load_taxon_products('Bestsellers')
      @trending_products = load_taxon_products('Trending')
    end

    private

    def load_taxon_products(taxon_name)
      Spree::Product.joins(:taxons).
        where(spree_taxons: { name: taxon_name }).
        includes(
          :variants_including_master,
                      master: [
                        :default_price,
                        { images: { attachment_attachment: :blob } }
                      ]
                    ).
        available.
        limit(12)
    end
  end
end
