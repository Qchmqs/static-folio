MAKEFLAGS += -s

# tools
MKDIR_P=mkdir -p
MKTARGETDIR=$(MKDIR_P) $(@D)
RM = rm -rf
HAML = haml
SASS = sass
COFFEE = coffee

# source
HAML_PATH = src/haml
SASS_PATH = src/sass
COFFEE_PATH = src/coffee

# public
ROOT_PATH = public
IMAGE_PATH = $(ROOT_PATH)/images
JS_PATH = $(ROOT_PATH)/js
CSS_PATH = $(ROOT_PATH)/css
FONT_PATH = $(ROOT_PATH)/fonts

# dependencies
BOOTSTRAP_PATH = vendor/bootstrap-3.3.6
BOOTSTRAP_SRC = $(BOOTSTRAP_PATH)/stylesheets
BOOTSTRAP_JS_SRC = $(wildcard $(BOOTSTRAP_PATH)/javascripts/bootstrap/*) $(wildcard $(BOOTSTRAP_PATH)/javascripts/*)
BOOTSTRAP_FONTS_SRC = $(wildcard $(BOOTSTRAP_PATH)/fonts/bootstrap/*)

BOOTSTRAP=$(CSS_PATH)/bootstrap.css
BOOTSTRAP_THEME=$(CSS_PATH)/bootstrap-theme.css
BOOTSTRAP_FONTS=$(patsubst $(BOOTSTRAP_PATH)/fonts/bootstrap/%, $(FONT_PATH)/bootstrap/%, $(BOOTSTRAP_FONTS_SRC))
BOOTSTRAP_JS=$(patsubst $(BOOTSTRAP_PATH)/javascripts/%, $(JS_PATH)/%, $(BOOTSTRAP_JS_SRC))

CS = $(wildcard $(COFFEE_PATH)/*.coffee)
LITCOFFEE = $(wildcard $(COFFEE_PATH)/*.litcoffee)

HTML_SRC = $(wildcard $(HAML_PATH)/*.html.haml)
SVG_SRC = $(wildcard $(HAML_PATH)/*.svg.haml)
CSS_SRC = $(wildcard $(SASS_PATH)/*.sass)
JS_SRC = $(COFFEE) $(LITCOFFEE)

SOURCE = $(HTML_SRC) $(SVG_SRC) $(CSS_SRC) $(JS_SRC)

HTML = $(patsubst $(HAML_PATH)/%.html.haml, $(ROOT_PATH)/%.html, $(HTML_SRC))
SVG = $(patsubst $(HAML_PATH)/%.svg.haml, $(IMAGE_PATH)/%.svg, $(SVG_SRC))
CSS = $(patsubst $(SASS_PATH)/%.sass, $(CSS_PATH)/%.css, $(CSS_SRC))

# HTML = $(HTML_HAML:.html.haml=.html)
# CSS = $(SASS:.sass=.css)

.PHONY: all watch bootstrap clean

all: $(HTML) $(SVG) $(CSS) bootstrap
	echo Build done.

watch:
	fswatch -o $(SOURCE) Makefile | xargs -n1 -I{} make

bootstrap: $(BOOTSTRAP) $(BOOTSTRAP_THEME) $(BOOTSTRAP_FONTS) $(BOOTSTRAP_JS)

$(BOOTSTRAP): $(BOOTSTRAP_SRC)/_bootstrap.scss
	$(SASS) $< $@

$(BOOTSTRAP_THEME): $(BOOTSTRAP_SRC)/bootstrap/_theme.scss
	$(SASS) $< $@

define make-html
$1: $(patsubst $(ROOT_PATH)/%, $(HAML_PATH)/%.haml, $1)
	$(MKDIR_P) $$(@D)
	$(HAML) $$< $$@
endef

define make-svg
$1: $(patsubst $(IMAGE_PATH)/%, $(HAML_PATH)/%.haml, $1)
	$(MKDIR_P) $$(@D)
	$(HAML) $$< $$@
endef

define make-css
$1: $(patsubst $(CSS_PATH)/%.css, $(SASS_PATH)/%.sass, $1)
	$(MKDIR_P) $$(@D)
	$(SASS) $$< $$@
endef

define make-font
$1: $(patsubst $(FONT_PATH)/bootstrap/%, $(BOOTSTRAP_PATH)/fonts/bootstrap/%, $1)
	$(MKDIR_P) $$(@D)
	cp $$< $$@
endef

define make-js
$1: $(patsubst $(JS_PATH)/%, $(BOOTSTRAP_PATH)/javascripts/%, $1)
	$(MKDIR_P) $$(@D)
	cp $$< $$@
endef

clean:
	$(RM) $(HTML)
	$(RM) $(SVG)
	$(RM) $(CSS)
	$(RM) $(BOOTSTRAP_FONTS)

$(foreach html_file,$(HTML),$(eval $(call make-html,$(html_file))))
$(foreach svg_file,$(SVG),$(eval $(call make-svg,$(svg_file))))
$(foreach css_file,$(CSS),$(eval $(call make-css,$(css_file))))

# bootstrap
$(foreach font_file,$(BOOTSTRAP_FONTS),$(eval $(call make-font,$(font_file))))
$(foreach js_file,$(BOOTSTRAP_JS),$(eval $(call make-js,$(js_file))))


