# frozen_string_literal: true

require "fileutils"

module Jekyll
  class JekyllI11lSitemap < Jekyll::Generator
    safe true
    priority :lowest

    # Main plugin action, called by Jekyll-core
    def generate(site)
      @site = site
      @site.pages << sitemap unless file_exists?("sitemap.xml")
      @site.pages << robots unless file_exists?("robots.txt")
    end

    private

    INCLUDED_EXTENSIONS = %w(
      .htm
      .html
      .xhtml
      .pdf
      .xml
    ).freeze

    # Matches all whitespace that follows
    #   1. A '>' followed by a newline or
    #   2. A '}' which closes a Liquid tag
    # We will strip all of this whitespace to minify the template
    MINIFY_REGEX = %r!(?<=>\n|})\s+!.freeze

    # Array of all jekyll pages with an HTML extension
    def i11l_pages
      pages = @site.pages.select do |page|
        page.html? || page.url.end_with?("/")
      end

      by_id = {}
      pages.each do |page|
        next unless page["lang_xref"] && page["lang"]

        by_id[page["lang_xref"]] ||= {}
        by_id[page["lang_xref"]][page["lang"]] = page
      end

      pages.map do |page|
        if page["lang"]
          page.data["translations"] =
            if translations = by_id[page["lang_xref"]].dup
              translations
            else
              # no translation, just link to itself to make the language known
              { page["lang"] => page }
            end
        end
        page
      end
    end

    # Array of all non-jekyll site files with an HTML extension
    def static_files
      @site.static_files.select { |file| INCLUDED_EXTENSIONS.include? file.extname }
    end

    # Path to sitemap.xml template file
    def source_path(file = "sitemap.xml")
      File.expand_path "../#{file}", __dir__
    end

    # Destination for sitemap.xml file within the site source directory
    def destination_path(file = "sitemap.xml")
      @site.in_dest_dir(file)
    end

    def sitemap
      site_map = PageWithoutAFile.new(@site, __dir__, "", "sitemap.xml")
      site_map.content = File.read(source_path).gsub(MINIFY_REGEX, "")
      site_map.data["layout"] = nil
      site_map.data["i11l_html_pages"] = i11l_pages.map(&:to_liquid)
      site_map.data["static_files"] = static_files.map(&:to_liquid)
      site_map.data["xsl"] = file_exists?("sitemap.xsl")
      site_map
    end

    def robots
      robots = PageWithoutAFile.new(@site, __dir__, "", "robots.txt")
      robots.content = File.read(source_path("robots.txt"))
      robots.data["layout"] = nil
      robots
    end

    # Checks if a file already exists in the site source
    def file_exists?(file_path)
      pages_and_files.any? { |p| p.url == "/#{file_path}" }
    end

    def pages_and_files
      @pages_and_files ||= @site.pages + @site.static_files
    end
  end
end
