MAKEFLAGS += -s

# tools
MKDIR_P=mkdir -p
MKTARGETDIR=$(MKDIR_P) $(@D)
RM = rm -rf
HAML = haml
SASS = sass -I vendor/bootstrap-3.3.6/stylesheets
COFFEE = coffee

# source
HAML_PATH = src/haml
SASS_PATH = src/sass
COFFEE_PATH = src/coffee
TTF_PATH = src/fonts

# public
ROOT_PATH = public
IMAGE_PATH = $(ROOT_PATH)/images
JS_PATH = $(ROOT_PATH)/js
CSS_PATH = $(ROOT_PATH)/css
FONT_PATH = $(ROOT_PATH)/fonts

# dependencies
BOOTSTRAP_PATH = vendor/bootstrap-3.3.6
BOOTSTRAP_SASS_PATH = $(BOOTSTRAP_PATH)/stylesheets
BOOTSTRAP_JS_SRC = $(wildcard $(BOOTSTRAP_PATH)/javascripts/bootstrap/*) $(wildcard $(BOOTSTRAP_PATH)/javascripts/*)
BOOTSTRAP_FONTS_SRC = $(wildcard $(BOOTSTRAP_PATH)/fonts/bootstrap/*)
BOOTSTRAP_SRC = $(wildcard $(BOOTSTRAP_SASS_PATH)/*.scss) $(wildcard $(BOOTSTRAP_SASS_PATH)/bootstrap/*.scss) $(wildcard $(BOOTSTRAP_SASS_PATH)/bootstrap/mixins/*.scss)

BOOTSTRAP=$(patsubst $(BOOTSTRAP_SASS_PATH)/%.scss, $(CSS_PATH)/%.css, $(BOOTSTRAP_SRC))
BOOTSTRAP_FONTS=$(patsubst $(BOOTSTRAP_PATH)/fonts/bootstrap/%, $(FONT_PATH)/bootstrap/%, $(BOOTSTRAP_FONTS_SRC))
BOOTSTRAP_JS=$(patsubst $(BOOTSTRAP_PATH)/javascripts/%, $(JS_PATH)/%, $(BOOTSTRAP_JS_SRC))

CS = $(wildcard $(COFFEE_PATH)/*.coffee)
LITCOFFEE = $(wildcard $(COFFEE_PATH)/*.litcoffee)

HTML_SRC = $(wildcard $(HAML_PATH)/*.html.haml)
SVG_SRC = $(wildcard $(HAML_PATH)/*.svg.haml)
FONT_SRC = $(wildcard $(TTF_PATH)/*.ttf)
CSS_SRC = $(wildcard $(SASS_PATH)/*.sass)
JS_SRC = $(COFFEE) $(LITCOFFEE)

SOURCE = $(HTML_SRC) $(SVG_SRC) $(CSS_SRC) $(JS_SRC) $(FONT_SRC)

HTML = $(patsubst $(HAML_PATH)/%.html.haml, $(ROOT_PATH)/%.html, $(HTML_SRC))
SVG = $(patsubst $(HAML_PATH)/%.svg.haml, $(IMAGE_PATH)/%.svg, $(SVG_SRC))
CSS = $(patsubst $(SASS_PATH)/%.sass, $(CSS_PATH)/%.css, $(CSS_SRC))
FONTS = $(patsubst $(TTF_PATH)/%.ttf, $(FONT_PATH)/%.ttf, $(FONT_SRC))

# HTML = $(HTML_HAML:.html.haml=.html)
# CSS = $(SASS:.sass=.css)

.PHONY: all watch bootstrap clean

all: $(HTML) $(SVG) $(CSS) $(FONTS) bootstrap
	echo Build done.

watch:
	fswatch -o $(SOURCE) Makefile | xargs -n1 -I{} make

bootstrap: $(BOOTSTRAP_FONTS) $(BOOTSTRAP_JS)

# $(BOOTSTRAP): $(BOOTSTRAP_SRC)/_bootstrap.scss
# 	$(SASS) $< $@

# $(BOOTSTRAP_THEME): $(BOOTSTRAP_SRC)/bootstrap/_theme.scss
# 	$(SASS) $< $@

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
$1: $(patsubst $(FONT_PATH)/%.ttf, $(TTF_PATH)/%.ttf, $(FONT_SRC))
	echo cp $$< $$@
	$(MKDIR_P) $$(@D)
	cp $$< $$@
endef

define make-bootstrap
$1: $(patsubst $(CSS_PATH)/%.css, $(BOOTSTRAP_SASS_PATH)/%.scss, $1)
	$(MKDIR_P) $$(@D)
	$(SASS) $$< $$@
endef

define make-bootstrap-font
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
	$(RM) $(FONTS)
	$(RM) $(BOOTSTRAP_FONTS)

$(foreach html_file, $(HTML),  $(eval $(call make-html, $(html_file))))
$(foreach font, $(FONTS),  $(eval $(call make-font, $(font))))
$(foreach svg_file,  $(SVG),   $(eval $(call make-svg,  $(svg_file))))
$(foreach css_file,  $(CSS),   $(eval $(call make-css,  $(css_file))))

# bootstrap
$(foreach bootstrap_file,$(BOOTSTRAP),$(eval $(call make-bootstrap,$(bootstrap_file))))
$(foreach bootstrap_font_file,$(BOOTSTRAP_FONTS),$(eval $(call make-bootstrap-font,$(bootstrap_font_file))))
$(foreach js_file,$(BOOTSTRAP_JS),$(eval $(call make-js,$(js_file))))


