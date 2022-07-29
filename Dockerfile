FROM python:3.7 as build-stage
WORKDIR /app
COPY ./docs .
RUN apt update -y && apt install apache2-utils -y
RUN htpasswd -cb /app/.user acompanhamento Desenvolvimento@123
RUN useradd nginx
RUN chown nginx /app/.user
RUN pip3.7 install -r requirements.txt
RUN make html

FROM twalter/openshift-nginx 
COPY ./nginx-config/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/build/html/ /usr/share/nginx/html/
COPY --from=build-stage /app/.user /etc/nginx/.user
EXPOSE 8081

# FROM nginx:stable
# RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
# COPY ./nginx-config/default.conf /etc/nginx/conf.d/default.conf
# RUN addgroup nginx root
# USER root
# COPY --from=build-stage /app/build/html/ /usr/share/nginx/html/
# EXPOSE 8081
