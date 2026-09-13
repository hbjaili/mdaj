/**
 * MDA Detox Theme progressive-enhancement entry point.
 * Add behaviour here only when it cannot be achieved accessibly with HTML/CSS.
 */
(function () {
	'use strict';

	document.documentElement.classList.add('mda-detox-js');

	var header = document.querySelector('.mda_detox_header');
	var headerScrollThreshold = 110;
	var headerUpdatePending = false;

	function updateHeaderState() {
		if (!header) {
			return;
		}

		header.classList.toggle(
			'mda_detox_header--scrolled',
			window.pageYOffset >= headerScrollThreshold
		);
		headerUpdatePending = false;
	}

	function requestHeaderUpdate() {
		if (headerUpdatePending) {
			return;
		}

		headerUpdatePending = true;
		window.requestAnimationFrame(updateHeaderState);
	}

	if (header) {
		updateHeaderState();
		window.addEventListener('scroll', requestHeaderUpdate, { passive: true });
	}

	function normalizeNavigationPath(url) {
		var parsedUrl = new URL(url, window.location.href);
		var path = parsedUrl.pathname.replace(/\/index(?:\.php)?\/?$/, '/');

		return {
			origin: parsedUrl.origin,
			path: path.replace(/\/+$/, '') || '/'
		};
	}

	function markCurrentNavigationItem() {
		var primaryNavigation;
		var currentLocation;
		var isJournalHomepage;
		var navigationItems;

		if (!header) {
			return;
		}

		primaryNavigation = header.querySelector('.pkp_navigation_primary');
		if (!primaryNavigation) {
			return;
		}

		currentLocation = normalizeNavigationPath(window.location.href);
		isJournalHomepage = document.body.classList.contains('pkp_page_index') &&
			document.body.classList.contains('pkp_op_index');
		navigationItems = primaryNavigation.children;

		Array.prototype.forEach.call(navigationItems, function (item, index) {
			var link = item.firstElementChild;
			var linkLocation;
			var isCurrentItem;

			if (!link || link.tagName.toLowerCase() !== 'a') {
				return;
			}

			linkLocation = normalizeNavigationPath(link.href);
			isCurrentItem = (
				linkLocation.origin === currentLocation.origin &&
				linkLocation.path === currentLocation.path
			) || (isJournalHomepage && index === 0);

			if (isCurrentItem) {
				item.classList.add('mda_detox_nav_item--current');
				link.setAttribute('aria-current', 'page');
			}
		});
	}

	markCurrentNavigationItem();

	var scrollTopButton = document.querySelector('.mda_detox_scroll_top');
	var scrollTopThreshold = 110;
	var scrollTopUpdatePending = false;

	function updateScrollTopState() {
		if (!scrollTopButton) {
			return;
		}

		scrollTopButton.classList.toggle(
			'mda_detox_scroll_top--visible',
			window.pageYOffset >= scrollTopThreshold
		);
		scrollTopUpdatePending = false;
	}

	function requestScrollTopUpdate() {
		if (scrollTopUpdatePending) {
			return;
		}

		scrollTopUpdatePending = true;
		window.requestAnimationFrame(updateScrollTopState);
	}

	if (scrollTopButton) {
		updateScrollTopState();
		window.addEventListener('scroll', requestScrollTopUpdate, { passive: true });
		scrollTopButton.addEventListener('click', function (event) {
			event.preventDefault();
			window.scrollTo({ top: 0, left: 0, behavior: 'smooth' });
		});
	}

	var typedWord = document.querySelector('.mda_detox_typed_word');
	var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

	if (!typedWord || reduceMotion) {
		return;
	}

	var word = typedWord.getAttribute('data-word') || typedWord.textContent.trim();
	var characterIndex = 0;
	var deleting = false;

	function animateWord() {
		if (deleting) {
			characterIndex -= 1;
		} else {
			characterIndex += 1;
		}

		typedWord.textContent = word.slice(0, characterIndex);

		if (!deleting && characterIndex === word.length) {
			deleting = true;
			window.setTimeout(animateWord, 3000);
			return;
		}

		if (deleting && characterIndex === 0) {
			deleting = false;
			window.setTimeout(animateWord, 700);
			return;
		}

		window.setTimeout(animateWord, deleting ? 65 : 115);
	}

	typedWord.textContent = '';
	window.setTimeout(animateWord, 900);
}());
